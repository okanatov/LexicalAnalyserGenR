# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'minitest/autorun'
require_relative '../lib/concatenation_node'
require_relative '../lib/syntax_tree_node'
require_relative '../lib/directed_graph'

include SyntaxTree
include Graph

# Tests the ConcatenationNode class.
class ConcatenationNodeTest < MiniTest::Test
  def setup
    left = SingleNode.new('a')
    right = SingleNode.new('b')
    @concatenation = ConcatenationNode.new(left, right)

    refute_nil(@concatenation)
  end

  def test_should_build_concatenation_graph
    graph = @concatenation.build(0)
    assert_equal('[[{"a"=>1}], [{"b"=>2}]]', graph.to_s)
  end

  def test_should_check_string_representation
    assert_equal('Concatenation: left=Node: character=a, right=Node: character=b', @concatenation.to_s)
  end
end
