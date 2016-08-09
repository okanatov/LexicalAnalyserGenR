require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/nfa'
require_relative '../lib/graph_utilities'

# Verifies the NFA class
class SimpleNFA < MiniTest::Test
  def setup
    @nfa_simple = NFA.from_string('abc')
    assert(nil != @nfa_simple)

    @nfa_alternation_1 = NFA.from_string('a(b|c)d')
    assert(nil != @nfa_alternation_1)

    @nfa_alternation_2 = NFA.from_string('ab|cd')
    assert(nil != @nfa_alternation_2)

    @nfa_complex = NFA.from_graph(
      GraphUtilities.combine(
        GraphUtilities.concatenation(
          GraphUtilities.concatenation(
            GraphUtilities.single_node('a'), GraphUtilities.single_node('b'),
          ),
          GraphUtilities.single_node('c')
        ),
        GraphUtilities.concatenation(
          GraphUtilities.concatenation(
            GraphUtilities.single_node('d'), GraphUtilities.single_node('e'),
          ),
          GraphUtilities.single_node('f')
        )
      )
    )
    assert(nil != @nfa_complex)
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

  def test_combination_matches_both_branches
    assert(@nfa_complex.matches?(StringIO.new('abc')), "NFA does not match \"abc\"")
    assert_equal(3, @nfa_complex.size)

    assert(@nfa_complex.matches?(StringIO.new('def')), "NFA does not match \"def\"")
    assert_equal(3, @nfa_complex.size)

    refute(@nfa_complex.matches?(StringIO.new('de')), "NFA does match \"de\"")

    refute(@nfa_complex.matches?(StringIO.new('g')), "NFA does match \"g\"")
  end
end
