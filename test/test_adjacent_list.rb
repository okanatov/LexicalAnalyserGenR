require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/adjacent_list'

class AdjacentListTest < MiniTest::Test
  def setup
    @g = AdjacentList.new # a graph structure under test
    @g.add_edge(0, 'a', 1)
    @g.add_edge(1, 'b', 2)
    @g.add_edge(1, 'c', 3)
    @g.add_edge(1, 'b', 6)
    @g.add_edge(2, 'd', 4)
    @g.add_edge(3, 'a', 5)

    @g.start = 0
    @g.end = 5
  end

  def test_to_s
    assert_equal("[[{\"a\"=>1}], [{\"b\"=>2}, {\"c\"=>3}, {\"b\"=>6}], [{\"d\"=>4}], [{\"a\"=>5}]]", @g.to_s)
  end

  def test_get_labels
    assert_equal("[\"a\"]", @g.labels(0).to_s)
    assert_equal("[\"b\", \"c\", \"b\"]", @g.labels(1).to_s)
    assert_equal("[\"a\"]", @g.labels(3).to_s)
  end

  def test_get_neigbours
    assert_equal('[1]', @g.neigbours(0).to_s)
    assert_equal('[2, 3, 6]', @g.neigbours(1).to_s)
    assert_equal('[5]', @g.neigbours(3).to_s)
  end

  def test_get_neigbous_via_label
    assert_equal('[]', @g.neigbour(0, 'b').to_s)
    assert_equal('[2, 6]', @g.neigbour(1, 'b').to_s)
    assert_equal('[5]', @g.neigbour(3, 'a').to_s)
  end

  def test_set_neigbous_via_label
    @g.set_neigbour(1, 'b', 5)
    assert_equal('[5, 5]', @g.neigbour(1, 'b').to_s)
    assert_equal('[5, 3, 5]', @g.neigbours(1).to_s)
  end

  def test_dfs
    assert_equal(%w(a c a), @g.dfs)
  end

  def test_append_another_graph_to_target
    @e = AdjacentList.new
    @e.add_edge(0, 'a', 1)
    @e.add_edge(1, 'b', 2)

    @g += @e
    assert_equal("[[{\"a\"=>1}], [{\"b\"=>2}, {\"c\"=>3}, {\"b\"=>6}], [{\"d\"=>4}], [{\"a\"=>5}], nil, nil, nil, [{\"a\"=>8}], [{\"b\"=>9}]]", @g.to_s)
  end

  def test_append_target_another_graph
    @e = AdjacentList.new
    @e.add_edge(0, 'a', 1)
    @e.add_edge(1, 'b', 2)

    @g = @e + @g
    assert_equal("[[{\"a\"=>1}], [{\"b\"=>2}], nil, [{\"a\"=>4}], [{\"b\"=>5}, {\"c\"=>6}, {\"b\"=>9}], [{\"d\"=>7}], [{\"a\"=>8}]]", @g.to_s)
  end

  def test_last
    assert_equal(6, @g.last)
  end

  def test_last_of_empty_graph
    e = AdjacentList.new
    assert_equal(-1, e.last)
  end
end
