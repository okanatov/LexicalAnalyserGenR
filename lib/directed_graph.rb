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

    # Creates a graph consisting of two vertices and an edge between them. The edge is associated
    # with the label.
    #
    # @param character [Char] the edge label.
    # @return [DirectedGraph] a new graph that consists of two vertices and an edge
    # between them.
    def self.single_node(character)
      graph = DirectedGraph.new
      graph.add_edge(0, 1, character)
      graph
    end

    # Adds one graph after another.
    #
    # @param first [DirectedGraph] a first graph.
    # @param second [DirectedGraph] a second graph followed by the first one.
    # @return [DirectedGraph] a new graph which contains both +:first+ and +:second+.
    def self.concatenation(first, second)
      raise ArgumentError, 'Parameter first is not DirectedGraph' unless first.is_a? DirectedGraph
      raise ArgumentError, 'Parameter second of the arguments is not DirectedGraph' unless second.is_a? DirectedGraph

      result = first
      offset = first.last
      copy_graph(second, result, offset)
      result
    end

    # Adds one graph to another paralelly.
    #
    # @param first [DirectedGraph] a first graph.
    # @param second [DirectedGraph] a second graph followed by the first one in parallel.
    # @return [DirectedGraph] a new graph which contains both +:first+ and +:second+.
    def self.alternation(first, second)
      raise ArgumentError, 'Parameter first is not DirectedGraph' unless first.is_a? DirectedGraph
      raise ArgumentError, 'Parameter second of the arguments is not DirectedGraph' unless second.is_a? DirectedGraph

      result = DirectedGraph.new

      # Add first empty transition and copy the first graph to result
      add_empty_transition_and_copy_graph(first, result, 0) # starting from 0 since result is empty

      offset = result.last

      # Add second empty transition and copy the second graph to result
      add_empty_transition_and_copy_graph(second, result, offset)

      # Add resulting empty transitions
      new_offset = result.last
      latest = new_offset + 1
      result.add_edge(offset, latest, :empty)
      result.add_edge(new_offset, latest, :empty)

      result
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

    # Gets a list of the edges associated with a vertex.
    #
    # @param vertex [Fixnum] a vertex.
    # @return [Array] a list of edges containing all the vertex neighbours together with
    # their characters
    def get_edges(vertex)
      (@vertices[vertex] || []).collect(&:clone)
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

    def final?(vertex)
      final_states = (0..last).select { |i| get_edges(i).empty? }
      final_states.include?(vertex)
    end

    def each(vertex)
      edges = get_edges(vertex)

      edges.each do |e|
        yield e.keys.first, e.values.first
      end
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
      (0..from.last).each do |i|
        edges = from.get_edges(i)
        copy_edges(edges, to, offset, i)
      end
    end

    # Copies edges of one graph to another graph with offset.
    #
    # @param edges [Array] the array of edges which are copied.
    # @param to [DirectedGraph] the graph to which the edges are copied.
    # @param offset [Fixnum] the offset in the +:graph+ graph from which the edges
    # are copied.
    # @return [DirectedGraph] +:self+.
    def self.copy_edges(edges, graph, offset, index)
      edges.each do |e|
        graph.add_edge(index + offset, e.values.first + offset, e.keys.first)
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
      edges = get_edges(vertex)
      edges.collect(&:values).flatten! || []
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
