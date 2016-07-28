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
require_relative '../lib/graph_utilities'
include Graph

# Tests the DirectedGraph class
class GraphUtilitiesTest < MiniTest::Test

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

  def test_should_join_two_one_edge_graphs_one_by_one
    result = GraphUtilities.concatenation(@one_edge, @one_edge)
    refute_nil(result)
    assert_equal('[[{"a"=>1}], [{"a"=>2}]]', result.to_s)
  end

  def test_should_join_two_three_edges_graphs_one_by_one
    result = GraphUtilities.concatenation(@three_edges, @three_edges)
    refute_nil(result)
    assert_equal('[[{"a"=>1}, {"c"=>3}], [{"b"=>2}], nil, [{"a"=>4}, {"c"=>6}], [{"b"=>5}]]', result.to_s)
  end

  def test_should_join_two_one_edge_graphs_in_parallel
    result = GraphUtilities.alternation(@one_edge, @one_edge)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], [{:empty=>5}], [{"a"=>4}], [{:empty=>5}]]', result.to_s)
  end

  def test_should_join_two_three_edges_graphs_in_parallel
    result = GraphUtilities.alternation(@three_edges, @three_edges)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>5}], [{"a"=>2}, {"c"=>4}], [{"b"=>3}], nil, [{:empty=>9}], [{"a"=>6}, {"c"=>8}], [{"b"=>7}], nil, [{:empty=>9}]]', result.to_s)
  end

  def test_should_join_first_simple_graph_to_second_parallel_graph_one_by_one
    result = GraphUtilities.alternation(@one_edge, @one_edge)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], [{:empty=>5}], [{"a"=>4}], [{:empty=>5}]]', result.to_s)

    result2 = GraphUtilities.concatenation(@one_edge, result)
    refute_nil(result2)
    assert_equal('[[{"a"=>1}], [{:empty=>2}, {:empty=>4}], [{"a"=>3}], [{:empty=>6}], [{"a"=>5}], [{:empty=>6}]]', result2.to_s)
  end

  def test_should_verity_impossibility_to_concate_two_numbers
    assert_raises ArgumentError do
      GraphUtilities.concatenation(0, @one_edge)
    end

    assert_raises ArgumentError do
      GraphUtilities.concatenation(@one_edge, 0)
    end

    assert_raises ArgumentError do
      GraphUtilities.concatenation(1, 0)
    end
  end

  def test_should_verity_impossibility_to_alternate_two_numbers
    assert_raises ArgumentError do
      GraphUtilities.alternation(0, @one_edge)
    end

    assert_raises ArgumentError do
      GraphUtilities.alternation(@one_edge, 0)
    end

    assert_raises ArgumentError do
      GraphUtilities.alternation(1, 0)
    end
  end

  def test_should_create_single_node
    graph = GraphUtilities.single_node('a')
    assert_equal('[[{"a"=>1}]]', graph.to_s)
  end

  def test_two_graphs_can_be_combined
    result = GraphUtilities.combine(@one_edge, @one_edge)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], nil, [{"a"=>4}]]', result.to_s)

    refute_nil(result)
    result = GraphUtilities.combine(result, @one_edge)
    assert_equal('[[{:empty=>1}, {:empty=>3}, {:empty=>5}], [{"a"=>2}], nil, [{"a"=>4}], nil, [{"a"=>6}]]', result.to_s)
  end
end
