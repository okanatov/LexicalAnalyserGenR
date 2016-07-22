require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/nfa'

# Verifies the NFA class
class SimpleNFA < MiniTest::Test
  def setup
    @nfa_simple = NFA.from_string('abc')
    assert(nil != @nfa_simple)

    @nfa_alternation_1 = NFA.from_string('a(b|c)d')
    assert(nil != @nfa_alternation_1)

    @nfa_alternation_2 = NFA.from_string('ab|cd')
    assert(nil != @nfa_alternation_2)
  end

  def test_does_not_match_def
    refute(@nfa_simple.matches?(StringIO.new("def")), "NFA does match \"def\"")
  end

  def test_does_not_match_dbabc
    refute(@nfa_simple.matches?(StringIO.new('dbabc')), "NFA does match \"dbabc\"")
  end

  def test_does_not_match_dabcef
    refute(@nfa_simple.matches?(StringIO.new('dabcef')), "NFA does match \"dabcef\"")
  end

  def test_matches_abc
    assert(@nfa_simple.matches?(StringIO.new("abc")), "NFA does not match \"abc\"")
    assert_equal(3, @nfa_simple.size)
  end

  def test_matches_abcdef
    assert(@nfa_simple.matches?(StringIO.new('abcdef')), "NFA does not match \"abcdef\"")
    assert_equal(3, @nfa_simple.size)
  end

  def test_alternation_1_matches_abd
    assert(@nfa_alternation_1.matches?(StringIO.new('abd')), "NFA does not match \"abd\"")
    assert_equal(3, @nfa_alternation_1.size)
  end

  def test_alternation_1_matches_acd
    assert(@nfa_alternation_1.matches?(StringIO.new('acd')), "NFA does not match \"acd\"")
    assert_equal(3, @nfa_alternation_1.size)
  end

  def test_alternation_2_ab
    assert(@nfa_alternation_2.matches?(StringIO.new('ab')), "NFA does not match \"ab\"")
    assert_equal(2, @nfa_alternation_2.size)
  end

  def test_alternation_2_cd
    assert(@nfa_alternation_2.matches?(StringIO.new('cd')), "NFA does not match \"cd\"")
    assert_equal(2, @nfa_alternation_2.size)
  end

  def test_longest
    nfa_alternation = NFA.from_string('long|longest')
    assert(nil != nfa_alternation)

    assert(nfa_alternation.matches?(StringIO.new('longest')), "NFA does not match \"longest\"")
    assert_equal(7, nfa_alternation.size)
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

    assert_equal('d', @nfa_alternation_1.get_next_token(io))
    assert_equal('acd', @nfa_alternation_1.get_next_token(io))
    assert_equal('e', @nfa_alternation_1.get_next_token(io))
    assert_equal(nil, @nfa_alternation_1.get_next_token(io))
  end

  def test_io11
    io = StringIO.new('dabde')

    assert_equal('d', @nfa_alternation_1.get_next_token(io))
    assert_equal('abd', @nfa_alternation_1.get_next_token(io))
    assert_equal('e', @nfa_alternation_1.get_next_token(io))
    assert_equal(nil, @nfa_alternation_1.get_next_token(io))
  end

  def test_io12
    @nfa_one_letter = NFA.from_string('a')
    assert(nil != @nfa_one_letter)

    io = StringIO.new('d')

    assert_equal('d', @nfa_one_letter.get_next_token(io))
    assert_equal(nil, @nfa_one_letter.get_next_token(io))
  end

  def test_io13
    @nfa_one_letter = NFA.from_string('a')
    assert(nil != @nfa_one_letter)

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
