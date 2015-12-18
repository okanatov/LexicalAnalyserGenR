require 'minitest/autorun'
require 'stringio'
require_relative '../lib/syntax_tree'

# Verifies the SyntaxTree class
class SimpleSyntaxTree < MiniTest::Test
  def test_concat
    tree = SyntaxTree.new(StringIO.new('ab c'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)
  end

  def test_single_chars_alternation
    tree = SyntaxTree.new(StringIO.new('a | b'))
    node = "#{tree.expr}"
    assert_equal('Node: data=|, left=Node: data=a, left=, right=, right=Node: data=b, left=, right=', node)
  end

  def test_sequence_alternation
    tree = SyntaxTree.new(StringIO.new('ab | cd'))
    node = "#{tree.expr}"
    assert_equal('Node: data=|, left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=., left=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_single_char_star
    tree = SyntaxTree.new(StringIO.new('a*'))
    node = "#{tree.expr}"
    assert_equal('Node: data=*, left=Node: data=a, left=, right=, right=*', node)
  end

  def test_few_chars_before_star
    tree = SyntaxTree.new(StringIO.new('abc*'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=*, left=Node: data=c, left=, right=, right=*', node)
  end

  def test_few_chars_after_star
    tree = SyntaxTree.new(StringIO.new('a*bc'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=*, left=Node: data=a, left=, right=, right=*, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)
  end

  def test_few_chars_surround_star
    tree = SyntaxTree.new(StringIO.new('ab*cd'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=*, left=Node: data=b, left=, right=, right=*, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_char_in_braces
    tree = SyntaxTree.new(StringIO.new('a(b)c'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=b, left=, right=, right=Node: data=c, left=, right=', node)

    tree1 = SyntaxTree.new(StringIO.new('abc'))
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_sequence_in_braces
    tree = SyntaxTree.new(StringIO.new('a(bc)d'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=., left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_alternation_in_braces
    tree = SyntaxTree.new(StringIO.new('a(b | c)d'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=|, left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=Node: data=d, left=, right=', node)
  end

  def test_single_char_in_braces_star
    tree = SyntaxTree.new(StringIO.new('a(b)*c'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=*, left=Node: data=b, left=, right=, right=*, right=Node: data=c, left=, right=', node)

    tree1 = SyntaxTree.new(StringIO.new('ab*c'))
    node1 = "#{tree1.expr}"
    assert_equal(node, node1)
  end

  def test_few_char_in_braces_star
    tree = SyntaxTree.new(StringIO.new('a(bc)*d'))
    node = "#{tree.expr}"
    assert_equal('Node: data=., left=Node: data=., left=Node: data=a, left=, right=, right=Node: data=*, left=Node: data=., left=Node: data=b, left=, right=, right=Node: data=c, left=, right=, right=*, right=Node: data=d, left=, right=', node)
  end
end
