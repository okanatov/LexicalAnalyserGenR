# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/directed_graph'
require_relative '../lib/graph_utilities'
include Graph

# Tests the DirectedGraph class
class DirectedGraphTest < MiniTest::Test

  def setup
    @one_edge = DirectedGraph.new
    @one_edge.add_edge(0, 1, 'a')
    refute_nil(@one_edge)

    @three_edges = DirectedGraph.new
    @three_edges.add_edge(0, 1, 'a')
    @three_edges.add_edge(1, 2, 'b')
    @three_edges.add_edge(0, 3, 'c')
    refute_nil(@three_edges)
  end

  def test_should_create_empty
    @empty = DirectedGraph.new
    refute_nil(@empty)
    assert_equal('[]', @empty.to_s)
  end

  def test_should_add_one_edge
    assert_equal('[[{"a"=>1}]]', @one_edge.to_s)
  end

  def test_should_add_a_few_edges
    assert_equal('[[{"a"=>1}, {"c"=>3}], [{"b"=>2}]]', @three_edges.to_s)
  end

  def test_should_add_same
    @one_edge.add_edge(0, 1, 'a')
    assert_equal('[[{"a"=>1}, {"a"=>1}]]', @one_edge.to_s)
  end

  def test_should_check_arguments_on_add_for_data_type
    assert_raises ArgumentError do
      @one_edge.add_edge('a', 1, 'a')
    end

    assert_raises ArgumentError do
      @one_edge.add_edge(0, 'a', 'a')
    end
  end

  def test_should_check_arguments_on_add_for_positiveness
    assert_raises ArgumentError do
      @one_edge.add_edge(-1, 1, 'a')
    end

    assert_raises ArgumentError do
      @one_edge.add_edge(-1, 0, 'a')
    end
  end

  def test_should_remove_one_edge
    @three_edges.remove_edge(0, 'a')
    assert_equal('[[{"c"=>3}], [{"b"=>2}]]', @three_edges.to_s)
  end

  def test_should_remove_latest
    @one_edge.remove_edge(0, 'a')
    refute_nil(@one_edge)
    assert_equal('[]', @one_edge.to_s)
  end

  def test_should_not_remove_non_existing_edge
    @one_edge.remove_edge(0, 'b')
    refute_nil(@one_edge)
    assert_equal('[[{"a"=>1}]]', @one_edge.to_s)
  end

  def test_should_check_arguments_on_removal_for_data_type
    assert_raises ArgumentError do
      @one_edge.remove_edge('a', 'a')
    end
  end

  def test_should_check_arguments_on_removal_for_positiveness
    assert_raises ArgumentError do
      @one_edge.remove_edge(-1, 'a')
    end
  end

  def test_check_finals
    refute(@three_edges.final?(0))
    refute(@three_edges.final?(1))
    assert(@three_edges.final?(2))
    assert(@three_edges.final?(3))
  end


  def test_should_check_each_iterates
    array = []
    (0..@three_edges.last).each do |vertex|
      @three_edges.each(vertex) do |char, vertex|
        array << char << vertex
      end
    end

    assert_equal('["a", 1, "c", 3, "b", 2]', array.to_s)
  end

  def test_should_check_each_does_not_change_internal_structure
    array = []
    (0..@three_edges.last).each do |vertex|
      @three_edges.each(vertex) do |char, vertex|
        vertex += 3
        array << char << vertex
      end
    end

    assert_equal('["a", 4, "c", 6, "b", 5]', array.to_s)
    assert_equal('[[{"a"=>1}, {"c"=>3}], [{"b"=>2}]]', @three_edges.to_s)
  end

  def test_should_get_last
    assert_equal(@three_edges.last, 3)
  end
end
