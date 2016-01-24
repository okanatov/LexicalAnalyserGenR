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

    graph_begin, _graph_end = from_syntax_tree(node, graph)
    graph.start = graph_begin

    new(graph)
  end

  def initialize(graph)
    @graph = graph
  end

  def matches?(string, method = :breadth)
    @found = false
    @end = 0

    (0..string.length).each do |i|
      @end = i
      if method == :breadth
        breadth_search(string[i..string.length])
      elsif method == :depth
        depth_search(@graph.start, string[i..string.length], @end)
        @end -= 1
      else
        break
      end
      break if @found
    end

    @found
  end

  def max_path
    max_path = []
    finals = (@graph.start..@graph.last).select { |e| @graph.final?(e) }

    finals.each do |e|
      @graph.end = e
      path = @graph.dfs
      max_path = path if path.length > max_path.length
    end
    max_path
  end

  def to_s
    @graph.to_s
  end

  private

  def self.from_syntax_tree(node, graph)
    if node.left.nil? && node.right.nil?
      return create_single_expression_from(node.data, graph)
    end

    if node.data == '.'
      left = from_syntax_tree(node.left, graph)
      right = from_syntax_tree(node.right, graph)

      labels = graph.labels(right[0])
      labels.each do |e|
        neigbours = graph.neigbour(right[0], e)
        neigbours.each do |i|
          graph.add_edge(left[1], e, i)
        end
        graph.remove_edge(right[0], e)
      end
      return [left[0], right[1]]
    elsif node.data == '|'
      start_idx = graph.last + 1
      graph.add_edge(start_idx, :empty, start_idx) # fake

      left = from_syntax_tree(node.left, graph)
      right = from_syntax_tree(node.right, graph)

      graph.remove_edge(start_idx, :empty) # fake

      last_idx = graph.last + 1

      graph.add_edge(start_idx, :empty, left[0])
      graph.add_edge(start_idx, :empty, right[0])
      graph.add_edge(left[1], :empty, last_idx)
      graph.add_edge(right[1], :empty, last_idx)
      return [start_idx, last_idx]
    end
    [nil, nil]
  end

  def self.create_single_expression_from(char, graph)
    start_idx = graph.last + 1
    graph.add_edge(start_idx, char, start_idx + 1)
    [start_idx, start_idx + 1]
  end

  def breadth_search(string)
    @old_states = []
    @new_states = []

    add_state(@old_states, @graph.start)

    string.each_char do |char|
      @old_states.each do |state|
        next_states = move(state, char)
        next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
      end

      break if @new_states.empty?

      @new_states.each { |s| @found = true if @graph.final?(s) }
      break if @found

      @old_states = @new_states.clone
      @new_states.clear

      @end += 1
    end
  end

  def depth_search(state, string, pos)
    if @graph.final?(state)
      @found = true
      @end = pos
    else
      s = adjacent_labels(state, string) # TODO: re-implement via the move method
      s.each do |i|
        arr = @graph.neigbour(state, i)
        arr.each do |e|
          if i == :empty
            depth_search(e, string[0..string.length], pos)
          else
            depth_search(e, string[1..string.length], pos.succ)
          end
          return if @found
        end
      end
    end
  end

  def adjacent_labels(state, string)
    @graph.labels(state).select { |i| (i == string[0..0]) || (i == :empty) }
  end

  def add_state(array, state)
    array.push(state)

    if @graph.labels(state).include?(:empty)
      @graph.neigbour(state, :empty).each { |e| array.push(e) }
    end
  end

  def move(state, char)
    if @graph.labels(state).include?(char)
      return @graph.neigbour(state, char)
    else
      return []
    end
  end
end
