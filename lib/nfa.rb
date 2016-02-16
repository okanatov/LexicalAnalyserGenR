require 'stringio'
require_relative './regexp_parser'
require_relative './adjacent_list'
require_relative './concatenation_node'
require_relative './alternation_node'

include SyntaxTree

# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA
  attr_reader :end

  def self.from_string(string)
    parser = RegexpParser.new(StringIO.new(string))
    node = parser.expr

    graph = AdjacentList.new
    graph_begin, _graph_end = node.interpret(graph)
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
        io = StringIO.new(string[i..string.length])
        breadth_search(io)
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

  def breadth_search(stringio)
    @old_states = []
    @new_states = []
    @states = []
    @chars = []

    add_state(@old_states, @graph.start)
    @states << @old_states.clone
    @chars << ''

    until stringio.eof?
      char = stringio.getc
      @old_states.each do |state|
        next_states = move(state, char)
        next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
      end

      break if @new_states.empty?
      @states << @new_states.clone
      @chars << char

      @old_states, @new_states = @new_states, @old_states
      @new_states.clear
    end

    @states.reverse_each do |e|
      e.each { |s| @found = true if @graph.final?(s) }
      break if @found
      @chars.pop
    end

    @end += (@chars.size - 2)
  end

  def depth_search(state, string, pos)
    if @graph.final?(state)
      @found = true
      @end = pos
    else
      edges = @graph.edges(state)
      edges.each do |edge|
        if edge.key?(string[0])
          depth_search(edge[string[0]], string[1..string.length], pos.succ)
        elsif edge.key?(:empty)
          depth_search(edge[:empty], string, pos)
        end
        break true if @found
      end
    end
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
