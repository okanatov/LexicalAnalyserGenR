# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'minitest/autorun'
require_relative '../lib/directed_graph'
include Graph

# Tests the DirectedGraph class
class DirectedGraphTest < MiniTest::Test
  def test_should_create_an_empty_graph_and_check_its_string_representation
    graph = DirectedGraph.new
    refute_nil(graph)
    assert_equal('[]', graph.to_s)
  end

  def test_should_add_one_edge_to_graph_and_check_string_representation
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')

    refute_nil(graph)
    assert_equal('[[{"a"=>1}]]', graph.to_s)
  end

  def test_should_add_a_few_edges_to_the_same_vertix
    graph = DirectedGraph.new

    graph.add_edge(0, 1, 'a')
    graph.add_edge(1, 2, 'b')
    graph.add_edge(0, 3, 'c')

    assert_equal('[[{"a"=>1}, {"c"=>3}], [{"b"=>2}]]', graph.to_s)
  end

  def test_should_remove_one_edge_from_graph
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')
    graph.add_edge(0, 2, 'b')

    graph.remove_edge(0, 'a')

    assert_equal('[[{"b"=>2}]]', graph.to_s)
  end

  def test_should_remove_the_latest_edge_from_graph
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')

    graph.remove_edge(0, 'a')

    assert_equal('[]', graph.to_s)
  end

  def test_should_verify_impossibility_to_change_graph_via_get_edges
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')
    graph.add_edge(1, 2, 'b')
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', graph.to_s)

    array = graph.get_edges(0)
    assert_equal('[{"a"=>1}]', array.to_s)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', graph.to_s)

    array[0]["a"] = 5
    assert_equal('[{"a"=>5}]', array.to_s)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', graph.to_s)
  end

  def test_should_join_two_simple_graphs_one_by_one
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'b')

    result = DirectedGraph.concatenation(first, second)

    refute_nil(result)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', result.to_s)
  end

  def test_should_join_two_graphs_one_by_one
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')
    first.add_edge(1, 2, 'b')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'a')
    second.add_edge(1, 2, 'b')

    result = DirectedGraph.concatenation(first, second)
    refute_nil(result)
    assert_equal('[[{"a"=>1}], [{"b"=>2}], [{"a"=>3}], [{"b"=>4}]]', result.to_s)
  end

  def test_should_join_two_complex_graphs_one_by_one
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')
    first.add_edge(0, 2, 'b')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'b')
    second.add_edge(0, 2, 'c')

    result = DirectedGraph.concatenation(first, second)
    refute_nil(result)
    assert_equal('[[{"a"=>1}, {"b"=>2}], nil, [{"b"=>3}, {"c"=>4}]]', result.to_s)
  end

  def test_should_join_two_simple_graphs_in_parallel
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'b')

    result = DirectedGraph.alternation(first, second)

    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], [{:empty=>5}], [{"b"=>4}], [{:empty=>5}]]', result.to_s)
  end

  def test_should_join_two_graphs_in_parallel
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')
    first.add_edge(1, 2, 'b')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'a')
    second.add_edge(1, 2, 'b')

    result = DirectedGraph.alternation(first, second)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>4}], [{"a"=>2}], [{"b"=>3}], [{:empty=>7}], [{"a"=>5}], [{"b"=>6}], [{:empty=>7}]]', result.to_s)
  end

  def test_should_join_two_complex_graphs_in_parallel
    first = DirectedGraph.new
    first.add_edge(0, 1, 'a')
    first.add_edge(0, 2, 'b')

    second = DirectedGraph.new
    second.add_edge(0, 1, 'b')
    second.add_edge(0, 2, 'c')

    result = DirectedGraph.alternation(first, second)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>4}], [{"a"=>2}, {"b"=>3}], nil, [{:empty=>7}], [{"b"=>5}, {"c"=>6}], nil, [{:empty=>7}]]', result.to_s)
  end

  def test_should_verity_impossibility_to_concate_two_numbers
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')

    assert_raises ArgumentError do
      DirectedGraph.concatenation(0, graph)
    end

    assert_raises ArgumentError do
      DirectedGraph.concatenation(graph, 0)
    end

    assert_raises ArgumentError do
      DirectedGraph.concatenation(1, 0)
    end
  end

  def test_should_verity_impossibility_to_alternate_two_numbers
    graph = DirectedGraph.new
    graph.add_edge(0, 1, 'a')

    assert_raises ArgumentError do
      DirectedGraph.alternation(0, graph)
    end

    assert_raises ArgumentError do
      DirectedGraph.alternation(graph, 0)
    end

    assert_raises ArgumentError do
      DirectedGraph.alternation(1, 0)
    end
  end
end
