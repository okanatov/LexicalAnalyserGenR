require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/lexer'

# Verifies the NFA class
class LexerTest < MiniTest::Test
  def setup
    @nfa_simple = Lexer.new('abc')
    assert(nil != @nfa_simple)

    @nfa_alternation = Lexer.new('a(b|c)d')
    assert(nil != @nfa_alternation)

    @nfa_one_letter = Lexer.new('a')
    assert(nil != @nfa_one_letter)
  end

  def test_io1
    io = StringIO.new('a')
    assert_equal('a', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io2
    io = StringIO.new('ab')
    assert_equal('a', @nfa_simple.get_next_token(io))
    assert_equal('b', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io3
    io = StringIO.new('abc')
    assert_equal('abc', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io4
    io = StringIO.new('abcd')
    assert_equal('abc', @nfa_simple.get_next_token(io))
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io5
    io = StringIO.new('abd')
    assert_equal('a', @nfa_simple.get_next_token(io))
    assert_equal('b', @nfa_simple.get_next_token(io))
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io6
    io = StringIO.new('d')
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io7
    io = StringIO.new('dabc')
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal('abc', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io8
    io = StringIO.new('dabcef')
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal('abc', @nfa_simple.get_next_token(io))
    assert_equal('e', @nfa_simple.get_next_token(io))
    assert_equal('f', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io9
    io = StringIO.new('dabe')
    assert_equal('d', @nfa_simple.get_next_token(io))
    assert_equal('a', @nfa_simple.get_next_token(io))
    assert_equal('b', @nfa_simple.get_next_token(io))
    assert_equal('e', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end

  def test_io10
    io = StringIO.new('dacde')

    assert_equal('d', @nfa_alternation.get_next_token(io))
    assert_equal('acd', @nfa_alternation.get_next_token(io))
    assert_equal('e', @nfa_alternation.get_next_token(io))
    assert_equal(nil, @nfa_alternation.get_next_token(io))
  end

  def test_io11
    io = StringIO.new('dabde')

    assert_equal('d', @nfa_alternation.get_next_token(io))
    assert_equal('abd', @nfa_alternation.get_next_token(io))
    assert_equal('e', @nfa_alternation.get_next_token(io))
    assert_equal(nil, @nfa_alternation.get_next_token(io))
  end

  def test_io12
    io = StringIO.new('d')
    assert_equal('d', @nfa_one_letter.get_next_token(io))
    assert_equal(nil, @nfa_one_letter.get_next_token(io))
  end

  def test_io13
    io = StringIO.new('a')
    assert_equal('a', @nfa_one_letter.get_next_token(io))
    assert_equal(nil, @nfa_one_letter.get_next_token(io))
  end

  def test_io14
    io = StringIO.new('ab')
    assert_equal('a', @nfa_simple.get_next_token(io))
    assert_equal('b', @nfa_simple.get_next_token(io))
    assert_equal(nil, @nfa_simple.get_next_token(io))
  end
end
