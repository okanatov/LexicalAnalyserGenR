require 'minitest/autorun'
require_relative '../lib/adjacent_list'

class AdjacentListTest < MiniTest::Test

  def setup
    @g = AdjacentList.new
  end

  def test_one_edge
    
    @g.add_edge(0, 1, 'a')
    assert_equal("[[{\"a\"=>1}]]", @g.to_s)
  end

  def test_two_edges_from_one_vertex
    
    @g.add_edge(0, 1, 'a')
    @g.add_edge(0, 2, 'b')
    assert_equal("[[{\"a\"=>1}, {\"b\"=>2}]]", @g.to_s)
  end

  def test_get_labels_when_two_edges_from_one_vertex
    
    @g.add_edge(0, 1, 'a')
    @g.add_edge(0, 2, 'b')
    assert_equal("[\"a\", \"b\"]", @g.labels(0).to_s)
  end

  def test_get_labels_on_empty_graph
    
    assert_equal("[]", @g.labels(0).to_s)
  end

  def test_get_all_vertices
    
    @g.add_edge(0, 1, 'a')
    @g.add_edge(1, 2, 'b')
    assert_equal("[0, 1]", @g.vertices.to_s)
  end

  def test_get_all_labels
    
    @g.add_edge(0, 1, 'a')
    @g.add_edge(0, 2, 'b')
    @g.add_edge(1, 2, 'c')

    labels = []
    @g.vertices.each { |e| @g.labels(e).each { |k| labels << k } }
    assert_equal("[\"a\", \"b\", \"c\"]", labels.to_s)
  end

  def test_traverse_all_vertices_full
    @g.add_edge(0, 1, 'a')
    @g.add_edge(1, 2, 'b')
    @g.add_edge(1, 3, 'c')
    @g.add_edge(2, 4, 'd')
    @g.add_edge(3, 5, 'a')
    @g.start = 0
    @g.end = 5
    assert_equal(["a", "c", "a"], @g.dfs)
  end

  def test_traverse_all_vertices_till_not_real_end
    @g.add_edge(0, 1, 'a')
    @g.add_edge(1, 2, 'b')
    @g.add_edge(1, 3, 'c')
    @g.add_edge(2, 4, 'd')
    @g.add_edge(3, 5, 'a')
    @g.start = 0
    @g.end = 4
    assert_equal(["a", "b", "d"], @g.dfs)
  end

  def test_traverse_all_vertices3_intermediate
    @g.add_edge(0, 1, 'a')
    @g.add_edge(1, 2, 'b')
    @g.add_edge(1, 3, 'c')
    @g.add_edge(2, 4, 'd')
    @g.add_edge(3, 5, 'a')
    @g.start = 1
    @g.end = 2
    assert_equal(["b"], @g.dfs)
  end
end
