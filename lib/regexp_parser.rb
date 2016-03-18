# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require_relative './syntax_tree_node'
require_relative './concatenation_node'
require_relative './alternation_node'
require_relative './star_node'

module SyntaxTree
  # Represents a parser that can build a syntax tree representation from a regular expression string.
  class RegexpParser
    # Initializes the parser that builds the syntax tree from the regular expression string.
    #
    # @param string [StringIO] the stringio object that keeps the regular expression string to be parsed.
    def initialize(string)
      @string = string
      @lookahead = ' ' # a character that is currently looked with the parser
      @lookahead = @string.getc while @lookahead =~ /[[:blank:]]/ # to by pass all the blank characters in the beginning
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
        node = SingleNode.new(@lookahead)
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
      AlternationNode.new(left, right)
    end

    def star(node)
      if node.instance_of?(SingleNode)
        StarNode.new(node)
      else
        temp = node.right
        right = StarNode.new(temp)
        concat(node.left, right)
      end
    end

    def concat(left, right)
      ConcatenationNode.new(left, right)
    end
  end
end
