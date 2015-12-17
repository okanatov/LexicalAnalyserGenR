# Represents a tree
class Tree
  def initialize(string)
    @string = string
    @lookahead = ' '
    @lookahead = @string.getc while @lookahead =~ /[[:blank:]]/
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

  def term
    if @lookahead =~ /[[:alnum:]]/
      node = Node.new(@lookahead, nil, nil)
      match(@lookahead)
      node
    else
      fail IOError
    end
  end

  def match(char)
    if @lookahead == char
      @lookahead = @string.getc

      @lookahead = @string.getc while @lookahead =~ /[[:blank:]]/
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

  def concat(left, right)
    Node.new('.', left, right)
  end

  def alternate(left, right)
    Node.new('|', left, right)
  end

  def star(node)
    if !node.right.nil?
      temp = node.right
      right = Node.new('*', temp, '*')
      node.right = right
    else
      node = Node.new('*', node, '*')
    end
    node
  end
end

# Represents a node in a tree
class Node
  attr_reader :data, :left
  attr_accessor :right

  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end

  def to_s
    "Node: data=#{@data}, left=#{@left}, right=#{@right}"
  end
end
