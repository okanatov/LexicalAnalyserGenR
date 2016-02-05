# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require_relative './adjacent_list'

module SyntaxTree
  # Represents a node in the syntax tree.
  class ConcatenationNode
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
      left_interpreted = left.interpret(graph)
      right_interpreted = right.interpret(graph)

      labels = graph.labels(right_interpreted[0])
      labels.each do |e|
        neigbours = graph.neigbour(right_interpreted[0], e)
        neigbours.each do |i|
          graph.add_edge(left_interpreted[1], e, i)
        end
        graph.remove_edge(right_interpreted[0], e)
      end
      [left_interpreted[0], right_interpreted[1]]
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      "Concatenation: left=#{@left}, right=#{@right}"
    end
  end
end
