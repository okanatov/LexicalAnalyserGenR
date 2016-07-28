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
  attr_reader :size

  def self.from_string(string)
    parser = RegexpParser.new(StringIO.new(string))
    node = parser.expr
    new(node.build)
  end

  def matches?(string)
    @queue = []
    @queue << add_state(0)
    @states = []
    @states << @queue.last

    until @queue.empty? || string.eof?
      char = string.getc
      current = @queue.shift

      new_states = []
      current.each do |state|
        next_states = move(state, char)
        next_states.each { |s| new_states << add_state(s) unless @queue.include?(s) }
      end
      @queue << new_states.flatten
      @states << @queue.last
    end

    compute_result
  end

  def to_s
    @graph.to_s
  end

  private


  def compute_result
    final_index = check_for_final
    if final_index
      @size = @states.size - 1 - final_index
      return true
    end

    false
  end

  def check_for_final
    @states.reverse!

    @states.each_index do |index|
      @states[index].each do |state|
        return index if @graph.final?(state)
      end
    end

    nil
  end

  def initialize(graph)
    @graph = graph
  end

  def add_state(state)
    array = []
    array.push(state)
    @graph.each(state) { |k, v| array << add_state(v) if k == :empty }
    array.flatten
  end

  def move(state, char)
    array = []
    @graph.each(state) { |k, v| array.push(v) if k == char }
    array
  end
end
