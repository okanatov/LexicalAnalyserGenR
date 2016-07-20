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
    @old_states = []
    @new_states = []
    @states = []

    add_state(@old_states, 0)
    @states << @old_states.clone

    until string.eof?
      char = string.getc

      @old_states.each do |state|
        next_states = move(state, char)
        next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
      end

      break if @new_states.empty?

      @states << @new_states.clone

      @old_states.clear
      @old_states = @new_states.clone
      @new_states.clear
    end

    @states.reverse!

    @states.each_index do |index|
      @states[index].each do |state|
        if @graph.final?(state)
          @size = @states.size - 1 - index
          return true
        end
      end
    end

    false
  end

  def to_s
    @graph.to_s
  end

  private

  def initialize(graph)
    @graph = graph
  end

  def add_state(array, state)
    array.push(state)

    @graph.each(state) do |k, v|
      array.push(v) if k == :empty
    end
  end

  def move(state, char)
    array = []

    @graph.each(state) do |k, v|
      array.push(v) if k == char
    end
    array
  end
end
