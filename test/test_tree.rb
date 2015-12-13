require 'minitest/autorun'
require 'stringio'
require_relative '../lib/tree'

# Verifies the Tree class
class SimpleTree < MiniTest::Test
  def test_concat
    tree = Tree.new(StringIO.new('23 5'))
    tree.parse
  end

  def test_plus_and_star
    tree = Tree.new(StringIO.new('2 + 3 * 5'))
    tree.parse
  end

  def test_plus_and_concat
    tree = Tree.new(StringIO.new('2 + 3 5'))
    tree.parse
  end
end
