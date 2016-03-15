# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'minitest/autorun'
require_relative '../lib/syntax_tree_node'
require_relative '../lib/directed_graph'

include SyntaxTree
include Graph

# Tests the SingleNode class
class SingleNodeTest < MiniTest::Test
  def setup
    @node = SingleNode.new('a')
    refute_nil(@node)
  end

  def test_should_check_representation_to_string
    assert_equal("Node: character=a", @node.to_s)
  end

  def test_should_build_a_simple_graph
    graph = @node.build
    assert_equal('[[{"a"=>1}]]', graph.to_s)
  end
end
