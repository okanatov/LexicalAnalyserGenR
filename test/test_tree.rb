require 'minitest/autorun'
require 'stringio'
require_relative '../lib/tree'

class SimpleTree < MiniTest::Test
    def test_simple_tree
        tree = Tree.new(StringIO.new("2 + 3 * 5"))
        tree.parse()
    end
end
