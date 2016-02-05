# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

module SyntaxTree
  # Represents a node in the syntax tree.
  class StarNode
    # @!attribute [r] node
    #   @return [SyntaxTreeNode] a reference to the node which the star operation is applied to.
    attr_reader :node

    # Initializes the node with some data as well as references to left and right leaves.
    #
    # @param data [Object] data that will be kept in the node.
    # @param left [SyntaxTreeNode] a reference to the left leaf.
    # @param right [SyntaxTreeNode] a reference to the right leaf.
    def initialize(node)
      @node = node
    end

    def interpret
      puts 'interpret stub from StarNode'
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      "Star: node=#{@node}"
    end
  end
end
