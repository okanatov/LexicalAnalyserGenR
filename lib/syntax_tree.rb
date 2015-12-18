# Represents a syntax tree
class SyntaxTree
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

# Represents a node in the syntax tree
class SyntaxTreeNode
  attr_reader :data, :left, :right

  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end

  def to_s
    "Node: data=#{@data}, left=#{@left}, right=#{@right}"
  end
end
