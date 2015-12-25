require 'minitest/autorun'
require_relative '../lib/adjacent_list'

class AdjacentListTest < MiniTest::Test
  def setup
    @g = AdjacentList.new
    @g.add_edge(0, 1, 'a')
    @g.add_edge(1, 2, 'b')
    @g.add_edge(1, 3, 'c')
    @g.add_edge(1, 6, 'b')
    @g.add_edge(2, 4, 'd')
    @g.add_edge(3, 5, 'a')

    @g.start = 0
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
    @e.add_edge(0, 1, 'a')
    @e.add_edge(1, 2, 'b')

    @g += @e
    assert_equal("[[{\"a\"=>1}], [{\"b\"=>2}, {\"c\"=>3}, {\"b\"=>6}], [{\"d\"=>4}], [{\"a\"=>5}], nil, nil, nil, [{\"a\"=>8}], [{\"b\"=>9}]]", @g.to_s)
  end

  def test_append_target_another_graph
    @e = AdjacentList.new
    @e.add_edge(0, 1, 'a')
    @e.add_edge(1, 2, 'b')

    @g = @e + @g
    assert_equal("[[{\"a\"=>1}], [{\"b\"=>2}], nil, [{\"a\"=>4}], [{\"b\"=>5}, {\"c\"=>6}, {\"b\"=>9}], [{\"d\"=>7}], [{\"a\"=>8}]]", @g.to_s)
  end

  def test_matches_aca
    assert(@g.matches('acab') == true)
  end
end
