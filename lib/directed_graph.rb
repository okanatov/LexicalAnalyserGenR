# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# Contains implementations of various types of graphs as well as
# functions to work with graphs.
module Graph
  # Represents a directed graph as an adjacency list, i.e. an array
  # of arrays, where the outer array contains the graph vertices, but the inner one
  # contains list of neighbors of a vertex.
  class DirectedGraph
    # Initializes an array of vertices.
    # Each array item keeps another array that represents list of neigbours of the vertex.
    # A neigbour is stored in a hash where a key is a label and the associated value is the
    # neigbour vertex.
    def initialize
      @vertices = []
    end

    # Returns the latest graph vertex.
    #
    # @return [Fixnum] index of the latest graph vertex.
    def last
      last = 0
      @vertices.each_index do |i|
        last = [get_max_from_neighbours(i), i, last].max
      end
      last
    end

    # Adds an edge, i.e. a neighbour vertex with the associated label.
    #
    # @param from [Fixnum] a vertex to which an edge is going to be added.
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
    # @param vertex [Fixnum] a vertex.
    # @param character [Char] a label.
    def remove_edge(vertex, character)
      validate_argument(vertex)

      edges = @vertices[vertex] || []
      edges.delete_if { |e| e.key?(character) }
      @vertices.delete_at(vertex) if edges.empty?
    end

    # Creates a string representation of +:self+.
    #
    # @return [String] a string representation of +:self+.
    def to_s
      @vertices.to_s
    end

    # Tests whether a given vertex is a final or not.
    #
    # @param vertex [Fixnum] a vertex.
    # @return [Boolean] true if the vertex is final and false otherwise
    # their characters
    def final?(vertex)
      final_states = (0..last).select { |i| @vertices[i].nil? }
      final_states.include?(vertex)
    end

    # Iterates all neighbours of a given vertex and performs a code block against each.
    #
    # @param vertex [Fixnum] a vertex neighbours of which are to be iterated.
    def each(vertex)
      edges = @vertices[vertex] || []

      edges.each do |e|
        yield e.keys.first, e.values.first
      end
    end

    private

    # Returns the max vertex from the list of neighbours of a vertex.
    #
    # @param [Fixnum] a vertex whose neighbours have to be examined for max value.
    # @return [Fixnum] the max value from the list of neighbours of a vertex.
    def get_max_from_neighbours(index)
      get_neighbours(index).max || 0
    end

    # Returns a list of neighbours associated with a vertex or an empty list.
    #
    # @param [Fixnum] a vertex which the list is returned for.
    # @return [Array] a list containing neighbours vertices indexes.
    def get_neighbours(vertex)
      neighbours = []
      each(vertex) do |_, v|
        neighbours << v
      end
      neighbours
    end

    # Validate the argument for correct type and that the argument is not negative
    #
    # @param [Fixnum] an argument being validated.
    def validate_argument(arg)
      raise ArgumentError, "Argument #{arg} is not Fixnum" unless arg.is_a? Fixnum
      raise ArgumentError, "Argument #{arg} is negative" if arg < 0
    end

    # Creates a new neighbours array for a vertex.
    #
    # @param [Fixnum] a vertex which the array is created for.
    # @return [DirectedGraph] +:self+
    def create_new(vertex)
      @vertices[vertex] = []
    end
  end
end
