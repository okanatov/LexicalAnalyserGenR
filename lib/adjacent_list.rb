# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015
# License::    Distributes under the same terms as Ruby

# This class represents a graph as an adjacency list, i.e. a collection
# of unordered lists, one for each vertex in the graph.
# Each list describes the set of neighbors of its vertex.

class AdjacentList

  attr_accessor :start, :end # the start vertex and the end one

  # Initializes an array of vertices.
  # Each array item keeps another array that represents neigbours of the vertix.
  # A neigbour is stored in a hash where a key is a label and the associated value is the
  # neigbour vertex.
  def initialize
    @vertices = [] # an array of the graph vertices
  end

  # Appends one graph to another.
  def +(other)
    start_idx = last + 1
    other.vertices.each_index do |i|
      next if other.vertices[i].nil?
      other.vertices[i].select! do |e|
        e.each_key { |k| e[k] = e[k] + start_idx }
      end
      @vertices[start_idx + i] = other.vertices[i]
    end
    @vertices
  end

  # Adds an edge, i.e. a neigbour vertex with the associated label.
  # FIXME: +y+ and +label+ parameters must be interchanged.
  def add_edge(x, y, label)
    if @vertices[x].nil?
      @vertices[x] = []
      @vertices[x][0] = { label => y }
    else
      last = @vertices[x].length
      @vertices[x][last] = { label => y }
    end
  end

  # Returns a list of all neigbours associated with the vertex.
  def neigbours(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.values.first }
    end
  end

  # Returns a list of neigbours associated with the vertex and the label.
  def neigbour(x, label)
    if @vertices[x].nil?
      return []
    else
      neigbours = @vertices[x].select { |e| e.key?(label) }
      neigbours.collect { |e| e.values.first }
    end
  end

  # Sets a value to all neigbours vertices associated with the vertex and the label.
  # FIXME: probably this method must be merged to the #add_edge method.
  def set_neigbour(x, label, y)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect! do |e|
        e[label] = y if e.key?(label)
        e
      end
    end
  end

  # Returns a list of all labels associated with the vertex.
  def labels(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.keys.first }
    end
  end

  # Returns the latest vertex in the graph.
  def last
    all_vertices = (0..@vertices.length).collect { |e| neigbours(e) }
    if all_vertices.flatten!.empty?
      return -1
    else
      all_vertices.sort!.last
    end
  end

  # Returns true if the vertex is final, i.e. it hasn't got any neigbours.
  def final?(vertix)
    final_states = (0..last).select { |e| @vertices.at(e).nil? }
    final_states.include?(vertix)
  end

  # Depth-first search (DFS) implementation.
  # An algorithm for traversing of the graph.
  def dfs
    @path = [] # an array containing the list of labels found.
    dfs_visit(@start)
    @path
  end

  # Creates a string representation of self.
  def to_s
    @vertices.to_s
  end

  protected

  attr_reader :vertices

  private

  # Implementation of the #dfs method.
  def dfs_visit(vertix)
    @found = true if vertix == @end
    return if @vertices[vertix].nil? || @found

    labels(vertix).each do |e|
      @path << e unless e == :empty

      neigbours = neigbour(vertix, e)
      neigbours.each { |n| dfs_visit(n) }

      break if @found
      @path.pop unless e == :empty

    end
  end
end
