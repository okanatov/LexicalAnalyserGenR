require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/regexp_parser'

include SyntaxTree

# Verifies the SyntaxTree class
class SimpleSyntaxTree < MiniTest::Test
  def test_concat
    tree = RegexpParser.new(StringIO.new('ab c'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Node: character=b, right=Node: character=c', node)
  end

  def test_single_chars_alternation
    tree = RegexpParser.new(StringIO.new('a | b'), 0)
    node = "#{tree.expr}"
    assert_equal('Alternation: left=Node: character=a, right=Node: character=b', node)
  end

  def test_sequence_alternation
    tree = RegexpParser.new(StringIO.new('ab | cd'), 0)
    node = "#{tree.expr}"
    assert_equal('Alternation: left=Concatenation: left=Node: character=a, right=Node: character=b, right=Concatenation: left=Node: character=c, right=Node: character=d', node)
  end

  def test_single_char_star
    tree = RegexpParser.new(StringIO.new('a*'), 0)
    node = "#{tree.expr}"
    assert_equal('Star: node=Node: character=a', node)
  end

  def test_few_chars_before_star
    tree = RegexpParser.new(StringIO.new('abc*'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Node: character=b, right=Star: node=Node: character=c', node)
  end

  def test_few_chars_after_star
    tree = RegexpParser.new(StringIO.new('a*bc'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Star: node=Node: character=a, right=Node: character=b, right=Node: character=c', node)
  end

  def test_few_chars_surround_star
    tree = RegexpParser.new(StringIO.new('ab*cd'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Concatenation: left=Node: character=a, right=Star: node=Node: character=b, right=Node: character=c, right=Node: character=d', node)
  end

  def test_char_in_braces
    tree = RegexpParser.new(StringIO.new('a(b)c'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Node: character=b, right=Node: character=c', node)

    tree1 = RegexpParser.new(StringIO.new('abc'), 0)
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_sequence_in_braces
    tree = RegexpParser.new(StringIO.new('a(bc)d'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Concatenation: left=Node: character=b, right=Node: character=c, right=Node: character=d', node)
  end

  def test_alternation_in_braces
    tree = RegexpParser.new(StringIO.new('a(b | c)d'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Alternation: left=Node: character=b, right=Node: character=c, right=Node: character=d', node)
  end

  def test_single_char_in_braces_star
    tree = RegexpParser.new(StringIO.new('a(b)*c'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Star: node=Node: character=b, right=Node: character=c', node)

    tree1 = RegexpParser.new(StringIO.new('ab*c'), 0)
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_few_char_in_braces_star
    tree = RegexpParser.new(StringIO.new('a(bc)*d'), 0)
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: character=a, right=Star: node=Concatenation: left=Node: character=b, right=Node: character=c, right=Node: character=d', node)
  end
end
