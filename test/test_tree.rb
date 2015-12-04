require 'minitest/autorun'
require_relative '../lib/tree'

class SimpleTree < MiniTest::Test
    def test_simple_tree
        tree = Tree.new(StringIO.new("a=b+c"))
    end
end
