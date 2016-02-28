# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# This module contains implementation of the directed graph as well as
# various functions to work with this graph.
module Graph
  # This class represents a graph as an adjacency list, i.e. an array
  # of arrays, one for each vertix in the graph.
  # Each array describes the set of neighbors of its vertix.
  class DirectedGraph
    # Initializes an array of vertices.
    # Each array item keeps another array that represents neigbours of the vertix.
    # A neigbour is stored in a hash where a key is a label and the associated value is the
    # neigbour vertix.
    def initialize
      @vertices = []
    end

    # Adds one graph after another and returns a new graph containing both graphs.
    #
    # @param first [DirectedGraph] a first graph.
    # @param second [DirectedGraph] a second graph followed by the first one.
    # @return [DirectedGraph] a new graph which contains both +:first+ and +:second+.
    def self.concatenation(first, second)
      raise ArgumentError, 'One of the arguments is not DirectedGraph' unless (first.is_a? DirectedGraph) && (second.is_a? DirectedGraph)

      result = first
      offset = first.last
      copy_graph(second, result, offset)
      result
    end

    # Adds one graph to another paralelly and returns a new graph
    # containing both graphs.
    #
    # @param first [DirectedGraph] a first graph.
    # @param second [DirectedGraph] a second graph followed by the first one in parallel.
    # @return [DirectedGraph] a new graph which contains both +:first+ and +:second+.
    def self.alternation(first, second)
      raise ArgumentError, 'One of the arguments is not DirectedGraph' unless (first.is_a? DirectedGraph) && (second.is_a? DirectedGraph)

      result = DirectedGraph.new

      # Add first empty transition and copy the first graph to result
      add_empty_transition_and_copy_graph(first, result, 0) # starting from 0 since result is empty

      # Add second empty transition and copy the second graph to result
      offset = result.last
      add_empty_transition_and_copy_graph(second, result, offset)

      # Add resulting empty transitions
      new_offset = result.last
      latest = new_offset + 1
      result.add_edge(offset, latest, :empty)
      result.add_edge(new_offset, latest, :empty)

      result
    end

    # Returns the latest vertix in the graph.
    #
    # @return [Fixnum] index of the latest vertix in the graph.
    def last
      last = 0
      @vertices.each_index do |index|
        last = [get_max_from_neighbours(index), index, last].max
      end
      last
    end

    # Gets a list of the edges associated with a vertix.
    #
    # @param vertix [Fixnum] a vertix.
    # @return [Array] a list of edges containing all the vertix neighbours together with
    # their characters
    def get_edges(vertix)
      (@vertices[vertix] || []).collect(&:clone)
    end

    # Adds an edge, i.e. a neighbour vertix with the associated label.
    #
    # @param from [Fixnum] a vertix to which an edge is going to be added.
    # @param to [Fixnum] a neighbour added with the edge.
    # @param character [Char] the edge label.
    # @return [DirectedGraph] +:self+.
    def add_edge(from, to, character)
      validate_argument(from)
      validate_argument(to)

      edges = @vertices[from] || create_new(from)
      edges << { character => to }
    end

    # Removes an edge.
    #
    # @param vertix [Fixnum] a vertix.
    # @param character [Char] a label.
    def remove_edge(vertix, character)
      validate_argument(vertix)

      edges = @vertices[vertix] || []
      edges.delete_if { |element| element.key?(character) }
      @vertices.delete_at(vertix) if edges.empty?
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      @vertices.to_s
    end

    private_class_method

    # Copies one graph to another with offset.
    #
    # @param from [DirectedGraph] the graph which is copied.
    # @param to [DirectedGraph] the graph to which the other graph is copied.
    # @param offset [Fixnum] the offset in the +:to+ graph from which the other
    # graph is copied.
    # @return [DirectedGraph] +:self+.
    def self.copy_graph(from, to, offset)
      (0..from.last).each do |index|
        edges = from.get_edges(index)
        copy_edges(edges, to, offset)
      end
    end

    # Copies edges of one graph to another graph with offset.
    #
    # @param edges [Array] the array of edges which are copied.
    # @param to [DirectedGraph] the graph to which the edges are copied.
    # @param offset [Fixnum] the offset in the +:graph+ graph from which the edges
    # are copied.
    # @return [DirectedGraph] +:self+.
    def self.copy_edges(edges, graph, offset)
      last = graph.last
      edges.each do |element|
        graph.add_edge(last, element.values.first + offset, element.keys.first)
      end
    end

    # Adds an empty transition and copies one graph to another with offset.
    #
    # @param from [DirectedGraph] the graph which is copied.
    # @param to [DirectedGraph] the graph to which the other graph is copied.
    # @param offset [Fixnum] the offset in the +:to+ graph from which the
    # empty transition is added and the the +:from+ graph is copied.
    # @return [DirectedGraph] +:self+.
    def self.add_empty_transition_and_copy_graph(from, to, offset)
      further_elem = offset + 1
      to.add_edge(0, further_elem, :empty)
      copy_graph(from, to, further_elem)
    end

    private

    # Returns the max vertix from the list of neighbours of a vertix.
    #
    # @param [Fixnum] a vertix whose neighbours have to be examined for max value.
    # @return [Fixnum] the max value from the list of neighbours of a vertix.
    def get_max_from_neighbours(index)
      get_neighbours(index).max || 0
    end

    # Returns a list of neighbours associated with a vertix or an empty list.
    #
    # @param [Fixnum] a vertix which the list is returned for.
    # @return [Array] a list containing neighbours vertices indexes.
    def get_neighbours(vertix)
      edges = get_edges(vertix)
      edges.collect(&:values).flatten! || []
    end

    # Validate the argument for correct type and that the argument is not negative
    #
    # @param [Fixnum] an argument being validated.
    def validate_argument(arg)
      raise ArgumentError, "Argument #{arg} is not Fixnum" unless arg.is_a? Fixnum
      raise ArgumentError, "Argument #{arg} is negative" if arg < 0
    end

    # Creates a new neighbours array for a vertix.
    #
    # @param [Fixnum] a vertix which the array is created for.
    # @return [DirectedGraph] +:self+
    def create_new(vertix)
      @vertices[vertix] = []
    end
  end
end
