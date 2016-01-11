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
      graph.add_edge(left[1], :empty, right[0])
      return [left[0], right[1]]
    end
  end

  def initialize(graph)
    @graph = graph
    @old_states = []
    @new_states = []
  end

  def matches?(string, method = :usual)
    @found = false
    @end = 0

    (0..string.length).each do |i|
      @end = i
      if method == :usual
        match_temp(string[i..string.length])
      elsif method == :backtrack
        bt(@graph.start, string[i..string.length], @end)
        @end -= 1
      else
        return false
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
    graph.add_edge(start_idx, char, start_idx + 1)
    [start_idx, start_idx + 1]
  end

  def match_temp(string)
    add_state(@old_states, @graph.start)

    string.each_char do |char|
      @old_states.each do |state|
        next_states = move(state, char)
        next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
      end

      break if @new_states.empty?

      @new_states.each do |s|
        if @graph.final?(s)
          @found = true
          return
        end
      end

      @old_states = @new_states.clone
      @new_states.clear

      @end += 1
    end
  end

  def bt(state, string, pos)
    if @graph.final?(state)
      @found = true
      @end = pos
      return
    end

    s = next_label(state, string)

    return if s.empty?

    s.each do |i|
      arr = @graph.neigbour(state, i)
      arr.each do |e|
        if i == :empty
          bt(e, string[0..string.length], pos)
        else
          bt(e, string[1..string.length], pos.succ)
        end
        return if @found
      end
    end
  end

  def next_label(state, string)
    @graph.labels(state).select { |i| (i == string[0..0]) || (i == :empty) }
  end

  def add_state(array, state)
    array.push(state)

    if @graph.labels(state).include? :empty
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
