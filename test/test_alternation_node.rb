# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'minitest/autorun'
require_relative '../lib/alternation_node'
require_relative '../lib/syntax_tree_node'
require_relative '../lib/directed_graph'

include SyntaxTree
include Graph

# Tests the AlternationNode class.
class AlternationNodeTest < MiniTest::Test
  def setup
    left = SingleNode.new('a')
    right = SingleNode.new('b')
    @alt = AlternationNode.new(left, right)

    refute_nil(@alt)
  end

  def test_should_build_concatenation_graph
    graph = @alt.build(0)
    assert_equal('[[{:empty=>1}, {:empty=>3}], [{"a"=>2}], [{:empty=>5}], [{"b"=>4}], [{:empty=>5}]]', graph.to_s)
  end

  def test_should_check_string_representation
    assert_equal('Alternation: left=Node: character=a, right=Node: character=b', @alt.to_s)
  end
end
