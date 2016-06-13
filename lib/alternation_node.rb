# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require_relative './directed_graph'

module SyntaxTree
  # Represents a node in the syntax tree.
  class AlternationNode
    include Graph

    # @!attribute [r] left
    #   @return [SyntaxTreeNode] a reference to the left leaf of the syntax tree.
    attr_reader :left

    # @!attribute [r] right
    #   @return [SyntaxTreeNode] a reference to the right leaf of the syntax tree.
    attr_reader :right

    # Initializes the node with some data as well as references to left and right leaves.
    #
    # @param left [SyntaxTreeNode] a reference to the left leaf.
    # @param right [SyntaxTreeNode] a reference to the right leaf.
    # @param from [Fixnum] a starting vertex number.
    def initialize(left, right, from = 0)
      @left = left
      @right = right
      @from = from
    end

    def build
      DirectedGraph.alternation(@left.build, @right.build, @from)
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      "Alternation: left=#{@left}, right=#{@right}"
    end
  end
end
