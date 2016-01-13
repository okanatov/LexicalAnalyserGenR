# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# This class represents a graph as an adjacency list, i.e. a collection
# of unordered lists, one for each vertix in the graph.
# Each list describes the set of neighbors of its vertix.
class AdjacentList
  # @!attribute start
  #   @return [Fixnum] a number of the first vertix in the graph.
  attr_accessor :start

  # @!attribute end
  #   @return [Fixnum] a number of the last vertix in the graph.
  attr_accessor :end

  # Initializes an array of vertices.
  # Each array item keeps another array that represents neigbours of the vertix.
  # A neigbour is stored in a hash where a key is a label and the associated value is the
  # neigbour vertix.
  def initialize
    @vertices = [] # an array of the graph vertices
  end

  # Appends one graph to another.
  #
  # @param other [AdjacentList] another graph to be appended to +:self+.
  # @return [AdjacentList] +:self+.
  def +(other)
    start_idx = last + 1 # next free index in :self
    other.vertices.each_index do |i|
      next if other.vertices[i].nil?
      other.vertices[i].select! do |e|
        e.each_key { |k| e[k] = e[k] + start_idx }
      end
      @vertices[start_idx + i] = other.vertices[i]
    end
    @vertices
  end

  # Adds an edge, i.e. a neigbour vertix with the associated label.
  #
  # @param vertix [Fixnum] a vertix to which an edge is going to be added.
  # @param label [Char] the edge label.
  # @param neigbour [Fixnum] a neigbour added with the edge.
  # @return [AdjacentList] +:self+.
  def add_edge(vertix, label, neigbour)
    if @vertices[vertix].nil?
      @vertices[vertix] = []
      @vertices[vertix][0] = { label => neigbour }
    else
      last = @vertices[vertix].length
      @vertices[vertix][last] = { label => neigbour }
    end
  end

  # Returns a list of all neigbours associated with the vertix.
  #
  # @param vertix [Fixnum] a vertix.
  # @return [Array] a list containing all the neigbours related to the vertix.
  def neigbours(vertix)
    if @vertices[vertix].nil?
      return []
    else
      @vertices[vertix].collect { |e| e.values.first }
    end
  end

  # Returns a list of neigbours associated with the vertix and the specific label.
  #
  # @param vertix [Fixnum] a vertix.
  # @param label [Char] a label.
  # @return [Array] a list containing all the neigbours related to the vertix and the specific label.
  def neigbour(vertix, label)
    if @vertices[vertix].nil?
      return []
    else
      neigbours = @vertices[vertix].select { |e| e.key?(label) }
      neigbours.collect { |e| e.values.first }
    end
  end

  # Sets a value to all neigbours vertices associated with the vertix and the label.
  #
  # @param vertix [Fixnum] a vertix.
  # @param label [Char] the edge label.
  # @param value [Fixnum] a new value to be set to neigbours vertices associated with the vertix and the label.
  # @return [AdjacentList] +:self+.
  #
  # @todo probably this method must be merged to the add_edge method.
  def set_neigbour(vertix, label, value)
    if @vertices[vertix].nil?
      return []
    else
      @vertices[vertix].collect! do |e|
        e[label] = value if e.key?(label)
        e
      end
    end
  end

  # Returns a list of all labels associated with the vertix.
  #
  # @param vertix [Fixnum] a vertix.
  # @return [Array] a list containing all the labels related to the vertix.
  def labels(vertix)
    if @vertices[vertix].nil?
      return []
    else
      @vertices[vertix].collect { |e| e.keys.first }
    end
  end

  # Returns the latest vertix in the graph.
  #
  # @return [Fixnum] the latest vertix in the graph or -1 if the graph is empty.
  def last
    all_vertices = (0..@vertices.length).collect { |e| neigbours(e) }
    if all_vertices.flatten!.empty?
      return -1
    else
      all_vertices.sort!.last
    end
  end

  # Returns true if the vertix is final, i.e. it hasn't got any neigbours.
  #
  # @param vertix [Fixnum] a vertix to be checked for final.
  # @return [Boolean] true if the vertix is final or false otherwise.
  def final?(vertix)
    final_states = (0..last).select { |e| @vertices.at(e).nil? }
    final_states.include?(vertix)
  end

  # Depth-first search (DFS) implementation.
  # An algorithm for traversing of the graph.
  #
  # @return [Array] a list containing labels to be visited from +:start+ to +:end+.
  def dfs
    @path = [] # an array containing a list of the labels found.
    dfs_visit(@start)
    @path
  end

  # Creates a string representation of +:self+.
  #
  # @return [String] a string representation of +:self+.
  def to_s
    @vertices.to_s
  end

  protected

  # @!attribute [r] vertices
  #   @return [Array] a list of all vertices in the graph.
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
