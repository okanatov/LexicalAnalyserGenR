# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

module Graph
  class GraphUtilities
    # Creates a graph consisting of two vertices and an edge between them.
    # The edge is associated with the label.
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

      result = DirectedGraph.new

      copy_graph(first, result, 0)
      offset = result.last
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

      # Copy the first graph
      alternate(first, result)

      # Get final position after first graph copying
      offset = result.last

      # Copy the second graph
      alternate(second, result)

      # Add resulting empty transitions
      new_offset = result.last
      latest = new_offset + 1
      result.add_edge(offset, latest, :empty)
      result.add_edge(new_offset, latest, :empty)

      result
    end

    # Joins two graphs parallelly but without ending empty transitions.
    #
    # @param first [DirectedGraph] a first graph.
    # @param second [DirectedGraph] a second graph.
    # @return [DirectedGraph] a new graph which contains both +:first+ and +:second+.
    def self.join(first, second)
      raise ArgumentError, 'Parameter first is not DirectedGraph' unless first.is_a? DirectedGraph
      raise ArgumentError, 'Parameter second of the arguments is not DirectedGraph' unless second.is_a? DirectedGraph

      result = DirectedGraph.new

      check = false
      first.each(0) { |k, v| check = true if k == :empty && v == 1 }

      if check
        copy_graph(first, result, 0)
      else
        alternate(first, result)
      end

      alternate(second, result)

      result
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
        from.each(i) do |k, v|
          to.add_edge(i + offset, v + offset, k)
        end
      end
    end

    def self.alternate(from, to)
      # Add empty transition from 0 to next vertex the first graph final position
      to.add_edge(0, to.last.succ, :empty)

      # Copy second graph starting from position +offset+ + 1
      copy_graph(from, to, to.last)
    end
  end
end
