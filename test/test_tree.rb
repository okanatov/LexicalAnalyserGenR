require 'minitest/autorun'
require 'stringio'
require_relative '../lib/tree'

# Verifies the Tree class
class SimpleTree < MiniTest::Test
  def test_simple_tree
    tree = Tree.new(StringIO.new('23 5)'))
    tree.parse
  end
end
