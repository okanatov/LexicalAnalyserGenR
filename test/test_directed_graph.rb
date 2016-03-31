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
include Graph

# Tests the DirectedGraph class
class DirectedGraphTest < MiniTest::Test

  def setup
    @graph = DirectedGraph.new
  end

  def test_should_create_empty
    refute_nil(@graph)
    assert_equal('[]', @graph.to_s)
  end

  def test_should_add_one_edge
    @graph.add_edge(0, 1, 'a')

    refute_nil(@graph)
    assert_equal('[[{"a"=>1}]]', @graph.to_s)
  end

  def test_should_add_a_few_edges

    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')
    @graph.add_edge(0, 3, 'c')

    assert_equal('[[{"a"=>1}, {"c"=>3}], [{"b"=>2}]]', @graph.to_s)
  end

  def test_should_create_same

    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')
    @graph.add_edge(0, 1, 'a')

    assert_equal('[[{"a"=>1}, {"a"=>1}], [{"b"=>2}]]', @graph.to_s)
  end

  def test_should_check_arguments_for_data_type

    assert_raises ArgumentError do
      @graph.add_edge('a', 1, 'a')
    end

    assert_raises ArgumentError do
      @graph.add_edge(0, 'a', 'a')
    end
  end

  def test_should_check_arguments_for_positiveness

    assert_raises ArgumentError do
      @graph.add_edge(-1, 1, 'a')
    end

    assert_raises ArgumentError do
      @graph.add_edge(-1, 0, 'a')
    end
  end

  def test_should_remove_one_edge

    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(0, 2, 'b')
    @graph.remove_edge(0, 'a')

    assert_equal('[[{"b"=>2}]]', @graph.to_s)
  end

  def test_should_remove_latest_edge

    @graph.add_edge(0, 1, 'a')
    @graph.remove_edge(0, 'a')

    assert_equal('[]', @graph.to_s)
  end

  def test_should_not_remove_non_existing_edge

    @graph.remove_edge(0, 'a')

    assert_equal('[]', @graph.to_s)
  end

  def test_should_check_arguments_for_data_type_on_edge_removal

    assert_raises ArgumentError do
      @graph.remove_edge('a', 'a')
    end
  end

  def test_should_check_arguments_for_positiveness_on_edge_removal

    assert_raises ArgumentError do
      @graph.remove_edge(-1, 'a')
    end
  end

  def test_should_verify_impossibility_to_change_graph_via_get_edges
    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', @graph.to_s)

    array = @graph.get_edges(0)
    assert_equal('[{"a"=>1}]', array.to_s)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', @graph.to_s)

    array[0]["a"] = 5
    assert_equal('[{"a"=>5}]', array.to_s)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', @graph.to_s)
  end

  def test_check_finals
    @graph.add_edge(0, 1, 'a')

    refute(@graph.final?(0))
    assert(@graph.final?(1))

    @graph.add_edge(1, 2, 'b')

    refute(@graph.final?(0))
    refute(@graph.final?(1))
    assert(@graph.final?(2))

    @graph.add_edge(0, 3, 'c')

    refute(@graph.final?(0))
    refute(@graph.final?(1))
    assert(@graph.final?(2))
    assert(@graph.final?(3))
  end


  def test_should_check_each_iterates
    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')
    @graph.add_edge(2, 3, 'c')
    @graph.add_edge(1, 4, 'd')

    array = []
    (0..@graph.last).each do |vertex|
      @graph.each(vertex) do |char, vertex|
        array << char << vertex
      end
    end

    assert_equal('["a", 1, "b", 2, "d", 4, "c", 3]', array.to_s)
  end

  def test_should_check_each_does_not_change_internal_structure
    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')

    array = []
    (0..@graph.last).each do |vertex|
      @graph.each(vertex) do |char, vertex|
        vertex += 3
        array << char << vertex
      end
    end

    assert_equal('["a", 4, "b", 5]', array.to_s)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', @graph.to_s)
  end

  def test_should_get_last
    @graph.add_edge(0, 1, 'a')
    @graph.add_edge(1, 2, 'b')
    @graph.add_edge(2, 3, 'c')
    @graph.add_edge(1, 4, 'd')

    assert_equal(@graph.last, 4)
  end

  def test_should_join_two_simple_graphs_one_by_one
    skip
    first.add_edge(0, 1, 'a')

    second.add_edge(0, 1, 'b')

    result = DirectedGraph.concatenation(first, second)

    refute_nil(result)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', result.to_s)
  end

  def test_should_join_two_graphs_one_by_one
    skip
    first.add_edge(0, 1, 'a')
    first.add_edge(1, 2, 'b')

    second.add_edge(0, 1, 'a')
    second.add_edge(1, 2, 'b')

    result = DirectedGraph.concatenation(first, second)
    refute_nil(result)
    assert_equal('[[{"a"=>1}], [{"b"=>2}], [{"a"=>3}], [{"b"=>4}]]', result.to_s)
  end

  def test_should_join_two_complex_graphs_one_by_one
    skip
    first.add_edge(0, 1, 'a')
    first.add_edge(0, 2, 'b')

    second.add_edge(0, 1, 'b')
    second.add_edge(0, 2, 'c')

    result = DirectedGraph.concatenation(first, second)
    refute_nil(result)
    assert_equal('[[{"a"=>1}, {"b"=>2}], nil, [{"b"=>3}, {"c"=>4}]]', result.to_s)
  end

  def test_should_join_two_simple_graphs_in_parallel
    skip
    first.add_edge(0, 1, 'a')

    second.add_edge(0, 1, 'b')

    result = DirectedGraph.alternation(first, second)

    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], [{:empty=>5}], [{"b"=>4}], [{:empty=>5}]]', result.to_s)
  end

  def test_should_join_two_graphs_in_parallel
    skip
    first.add_edge(0, 1, 'a')
    first.add_edge(1, 2, 'b')

    second.add_edge(0, 1, 'a')
    second.add_edge(1, 2, 'b')

    result = DirectedGraph.alternation(first, second)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>4}], [{"a"=>2}], [{"b"=>3}], [{:empty=>7}], [{"a"=>5}], [{"b"=>6}], [{:empty=>7}]]', result.to_s)
  end

  def test_should_join_two_complex_graphs_in_parallel
    skip
    first.add_edge(0, 1, 'a')
    first.add_edge(0, 2, 'b')

    second.add_edge(0, 1, 'b')
    second.add_edge(0, 2, 'c')

    result = DirectedGraph.alternation(first, second)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>4}], [{"a"=>2}, {"b"=>3}], nil, [{:empty=>7}], [{"b"=>5}, {"c"=>6}], nil, [{:empty=>7}]]', result.to_s)
  end

  def test_should_join_first_simple_graph_to_second_parallel_graph_one_by_one
    skip
    first.add_edge(0, 1, 'a')

    second.add_edge(0, 1, 'b')

    third.add_edge(0, 1, 'c')

    result = DirectedGraph.alternation(second, third)
    refute_nil(result)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"b"=>2}], [{:empty=>5}], [{"c"=>4}], [{:empty=>5}]]', result.to_s)

    result2 = DirectedGraph.concatenation(first, result)
    refute_nil(result2)
    assert_equal('[[{"a"=>1}], [{:empty=>2}, {:empty=>4}], [{"b"=>3}], [{:empty=>6}], [{"c"=>5}], [{:empty=>6}]]', result2.to_s)
  end

  def test_should_verity_impossibility_to_concate_two_numbers
    skip
    @graph.add_edge(0, 1, 'a')

    assert_raises ArgumentError do
      DirectedGraph.concatenation(0, @graph)
    end

    assert_raises ArgumentError do
      DirectedGraph.concatenation(@graph, 0)
    end

    assert_raises ArgumentError do
      DirectedGraph.concatenation(1, 0)
    end
  end

  def test_should_verity_impossibility_to_alternate_two_numbers
    skip
    @graph.add_edge(0, 1, 'a')

    assert_raises ArgumentError do
      DirectedGraph.alternation(0, @graph)
    end

    assert_raises ArgumentError do
      DirectedGraph.alternation(@graph, 0)
    end

    assert_raises ArgumentError do
      DirectedGraph.alternation(1, 0)
    end
  end
end
