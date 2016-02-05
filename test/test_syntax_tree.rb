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
    tree = RegexpParser.new(StringIO.new('ab c'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)
  end

  def test_single_chars_alternation
    tree = RegexpParser.new(StringIO.new('a | b'))
    node = "#{tree.expr}"
    assert_equal('Alternation: left=Node: data=a, left=, right=, right=Node: data=b, left=, right=', node)
  end

  def test_sequence_alternation
    tree = RegexpParser.new(StringIO.new('ab | cd'))
    node = "#{tree.expr}"
    assert_equal('Alternation: left=Concatenation: left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Concatenation: left=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_single_char_star
    tree = RegexpParser.new(StringIO.new('a*'))
    node = "#{tree.expr}"
    assert_equal('Star: node=Node: data=a, left=, right=', node)
  end

  def test_few_chars_before_star
    tree = RegexpParser.new(StringIO.new('abc*'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Star: node=Node: data=c, left=, right=', node)
  end

  def test_few_chars_after_star
    tree = RegexpParser.new(StringIO.new('a*bc'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Star: node=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)
  end

  def test_few_chars_surround_star
    tree = RegexpParser.new(StringIO.new('ab*cd'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Star: node=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_char_in_braces
    tree = RegexpParser.new(StringIO.new('a(b)c'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)

    tree1 = RegexpParser.new(StringIO.new('abc'))
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_sequence_in_braces
    tree = RegexpParser.new(StringIO.new('a(bc)d'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Concatenation: left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_alternation_in_braces
    tree = RegexpParser.new(StringIO.new('a(b | c)d'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Alternation: left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_single_char_in_braces_star
    tree = RegexpParser.new(StringIO.new('a(b)*c'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Star: node=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)

    tree1 = RegexpParser.new(StringIO.new('ab*c'))
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_few_char_in_braces_star
    tree = RegexpParser.new(StringIO.new('a(bc)*d'))
    node = "#{tree.expr}"
    assert_equal('Concatenation: left=Concatenation: left=Node: data=a, left=, right=, right=Star: node=Concatenation: left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end
end
