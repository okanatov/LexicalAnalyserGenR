# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require_relative './adjacent_list'

module SyntaxTree
  # Represents a node in the syntax tree.
  class AlternationNode
    # @!attribute [r] left
    #   @return [SyntaxTreeNode] a reference to the left leaf of the syntax tree.
    attr_reader :left

    # @!attribute [r] right
    #   @return [SyntaxTreeNode] a reference to the right leaf of the syntax tree.
    attr_reader :right

    # Initializes the node with some data as well as references to left and right leaves.
    #
    # @param data [Object] data that will be kept in the node.
    # @param left [SyntaxTreeNode] a reference to the left leaf.
    # @param right [SyntaxTreeNode] a reference to the right leaf.
    def initialize(left, right)
      @left = left
      @right = right
    end

    def interpret(graph)
      reserved = reserve_vertix(graph)

      left_interpreted = left.interpret(graph)
      right_interpreted = right.interpret(graph)

      unreserve_vertex(graph, reserved)

      last_idx = graph.last + 1
      graph.add_edge(reserved, :empty, left_interpreted[0])
      graph.add_edge(reserved, :empty, right_interpreted[0])
      graph.add_edge(left_interpreted[1], :empty, last_idx)
      graph.add_edge(right_interpreted[1], :empty, last_idx)
      [reserved, last_idx]
    end

    def reserve_vertix(graph)
      start_idx = graph.last + 1
      graph.add_edge(start_idx, :empty, start_idx)
      start_idx
    end

    def unreserve_vertex(graph, vertex)
      graph.remove_edge(vertex, :empty)
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      "Alternation: left=#{@left}, right=#{@right}"
    end
  end
end
