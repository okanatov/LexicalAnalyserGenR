require 'stringio'
require_relative './syntax_tree'
require_relative './adjacent_list'

# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA

  attr_reader :end

  def self.from_string(string)
    tree = SyntaxTree.new(StringIO.new(string))
    graph = AdjacentList.new

    node = tree.expr

    from_syntax_tree(node, graph)
    graph.start = 0

    new(graph)
  end

  def self.from_syntax_tree(node, graph)
    if node.left.nil? && node.right.nil?
      return create_single_expression_from(node.data, graph)
    end

    left = from_syntax_tree(node.left, graph)
    right = from_syntax_tree(node.right, graph)

    if node.data == '.'
      graph.add_edge(left[1], right[0], :empty)
      return [left[0], right[1]]
    end
  end

  def initialize(graph)
    @graph = graph
    @old_states = []
    @new_states = []
  end

  def matches(string)
    @end = 0
    @old_states.push(@graph.start)

    string.each_char do |i|
      @old_states.each do |j|
        s = move(j, i)
        s.each { |e| add_state(e) unless @new_states.include?(e) }
      end

      @old_states = @new_states.clone
      @new_states.clear

      @old_states.each do |i|
        return true if @graph.final?(i)
      end
      @end += 1
    end
    false
  end

  def matches_bt(string)
    @found = false
    @end = -1
    (0..string.length).each do |i|
      bt(@graph.start, string[i..string.length])
      break if @found
      @end += 1
    end
    @found
  end

  def max_path
    max_path = []
    finals = (@graph.start..@graph.last).select { |e| @graph.final?(e) }

    finals.each do |e|
      @graph.end = e
      path = @graph.dfs

      if path.length > max_path.length
        max_path = path
      end
    end
    max_path
  end

  def to_s
    @graph.to_s
  end

  private

  def self.create_single_expression_from(char, graph)
    start_idx = graph.last + 1
    graph.add_edge(start_idx, start_idx + 1, char)
    [start_idx, start_idx + 1]
  end

  def bt(state, string)
    return if reject(state, string)
    if accept(state)
      @found = true
      return
    end

    s = first(state, string)
    s.each do |i|
      arr = @graph.neigbour(state, i)
      arr.each do |e|
        if i == :empty
          bt(e, string[0..string.length])
        else
          bt(e, string[1..string.length])
          @end += 1
        end
      end
      break if @found
    end
  end

  def reject(state, string)
    if @graph.final?(state) || @graph.labels(state).include?(string[0..0]) || @graph.labels(state).include?(:empty)
      return false
    else
      return true
    end
  end

  def accept(state)
    @graph.final?(state)
  end

  def first(state, string)
    @graph.labels(state).select { |i| (i == string[0..0]) || (i == :empty) }
  end

  def move(state, char)
    if @graph.labels(state).include?(char)
      return @graph.neigbour(state, char)
    else
      return [state]
    end
  end

  def add_state(state)
    @new_states.push(state)

    if @graph.labels(state).include? :empty
      @graph.neigbour(state, :empty).each { |e| @new_states.push(e) }
    end
  end
end
