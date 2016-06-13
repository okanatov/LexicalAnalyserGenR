# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require_relative './directed_graph'

module SyntaxTree
  # Represents a single node in the syntax tree.
  class SingleNode
    include Graph

    # @!attribute [r] character
    #   @return [Char] the character associated with this node.
    attr_reader :character

    # Initializes the node with a character.
    #
    # @param character [Char] the character associated with the node.
    # @param from [Fixnum] a starting vertex number.
    def initialize(character, from = 0)
      @character = character
      @from = from
    end

    def build
      DirectedGraph.single_node(@character, @from)
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      "Node: character=#{@character}"
    end
  end
end
