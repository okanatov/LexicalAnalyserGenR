require 'stringio'
require_relative './regexp_parser'
require_relative './directed_graph'
require_relative './concatenation_node'
require_relative './alternation_node'

include SyntaxTree
include Graph

# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA
  attr_reader :end

  def self.from_string(string)
    parser = RegexpParser.new(StringIO.new(string))
    node = parser.expr
    new(node.build)
  end

  def matches?(string, method = :breadth)
    @found = false
    @end = 0

    (0..string.length-1).each do |i|
      @end = i
      if method == :breadth
        io = StringIO.new(string[i..string.length])
        breadth_search(io)
      elsif method == :depth
        depth_search(0, string[i..string.length], @end)
      else
        break
      end
      break if @found
    end

    @found
  end

  def to_s
    @graph.to_s
  end

  private

  def initialize(graph)
    @graph = graph
  end

  def breadth_search(stringio)
    @old_states = []
    @new_states = []
    @dfa_states = []

    add_state(@old_states, 0)
    @dfa_states << @old_states.clone

    until stringio.eof?
      char = stringio.getc
      @old_states.each do |state|
        next_states = move(state, char)
        next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
      end

      break if @new_states.empty?
      @dfa_states << @new_states.clone

      @old_states, @new_states = @new_states, @old_states
      @new_states.clear
    end

    dfa_states_len = calculate_states
    @end = @end + dfa_states_len - 1
  end

  def calculate_states
    states_len = @dfa_states.length
    @dfa_states.reverse_each do |e|
      e.each { |s| @found = true if @graph.final?(s) }
      break if @found
      states_len -= 1
    end
    states_len - 1
  end

  def depth_search(state, string, pos)
    if @graph.final?(state)
      @found = true
      @end = pos - 1
    else
      @graph.each(state) do |k, v|
        if k == string[0]
          depth_search(v, string[1..string.length], pos.succ)
        elsif k == :empty
          depth_search(v, string, pos)
        end
        break true if @found
      end
    end
  end

  def add_state(array, state)
    array.push(state)

    @graph.each(state) do |k, v|
      if k == :empty
        array.push(v)
      end
    end
  end

  def move(state, char)
    array = []

    @graph.each(state) do |k, v|
      if k == char
        array.push(v)
      end
    end
    array
  end
end
