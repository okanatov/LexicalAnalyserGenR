# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# This class represents a syntax tree.

class SyntaxTree

  # Initializes the parser.
  #
  # @param string [StringIO] the stringio object that keeps the regular expression to be parsed.
  def initialize(string)
    @string = string
    @lookahead = ' ' # a character that is currently looked with the parser
    @lookahead = @string.getc while @lookahead =~ /[[:blank:]]/ # to by pass all the blank characters
  end

  def expr
    if @lookahead == '('
      match('(')
      left = expr
      match(')')
    else
      left = term
    end
    rest(left)
  end

  private

  def match(char)
    if @lookahead == char
      @lookahead = ' '
      @lookahead = @string.getc while @lookahead =~ /[[:blank:]]/
    else
      fail IOError
    end
  end

  def term
    if @lookahead =~ /[[:alnum:]]/
      node = SyntaxTreeNode.new(@lookahead, nil, nil)
      match(@lookahead)
      node
    else
      fail IOError
    end
  end

  def rest(left)
    if @lookahead == '|'
      match('|')
      right = expr
      left = alternate(left, right)
      left = rest(left)
    elsif @lookahead == '*'
      match('*')
      left = star(left)
      left = rest(left)
    elsif @lookahead =~ /[[:alnum:]]/
      right = term
      left = concat(left, right)
      left = rest(left)
    elsif @lookahead == '('
      match('(')
      right = expr
      match(')')
      left = concat(left, right)
      left = rest(left)
    end
    left
  end

  def alternate(left, right)
    SyntaxTreeNode.new('|', left, right)
  end

  def star(node)
    if !node.right.nil?
      temp = node.right
      right = SyntaxTreeNode.new('*', temp, '*')
      concat(node.left, right)
    else
      SyntaxTreeNode.new('*', node, '*')
    end
  end

  def concat(left, right)
    SyntaxTreeNode.new('.', left, right)
  end
end

# Represents a node in the syntax tree.

class SyntaxTreeNode

  # @!attribute [r] data
  #   @return [Object] data that is kept in the node.
  attr_reader :data

  # @!attribute [r] left
  #   @return [SyntaxTreeNode] a reference to the left leaf of the syntax tree.
  attr_reader :left

  # @!attribute [r] right
  #   @return [SyntaxTreeNode] a reference to the right leaf of the syntax tree.
  attr_reader :right

  # Initializes the node.
  #
  # @param data [Object] data that will be kept in the node.
  # @param left [SyntaxTreeNode] a reference to the left leaf.
  # @param right [SyntaxTreeNode] a reference to the right leaf.
  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end

  # Creates a string representation of +:self+.
  #
  # @return [String] a string representation of +:self+.
  def to_s
    "Node: data=#{@data}, left=#{@left}, right=#{@right}"
  end
end
