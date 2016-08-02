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

  def self.from_graph(graph)
    new(graph)
  end

  def matches?(string)
    init

    until string.eof?
      compute_new_states(string.getc)
      break if @new_states.empty?
      step
    end

    compute_result
  end

  private

  def init
    @old_states = []
    @new_states = []
    @states = []

    add_state(@old_states, 0)
    @states << @old_states.clone
  end

  def compute_new_states(char)
    @old_states.each do |state|
      next_states = move(state, char)
      next_states.each { |s| add_state(@new_states, s) unless @new_states.include?(s) }
    end
  end

  def step
    @states << @new_states.clone

    @old_states.clear
    @old_states = @new_states.clone
    @new_states.clear
  end

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

  def add_state(array, state)
    array.push(state)
    @graph.each(state) { |k, v| add_state(array, v) if k == :empty }
  end

  def move(state, char)
    array = []
    @graph.each(state) { |k, v| array.push(v) if k == char }
    array
  end
end
