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
  end

  def test_does_not_match
    refute(@nfa_simple.matches?('def'), "NFA matches \"abc\"")
    refute(@nfa_simple.matches?('def', :depth), "NFA matches \"abc\"")
  end

  def test_simple_apply_abcdef
    assert(@nfa_simple.matches?('abcdef'), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)

    assert(@nfa_simple.matches?('abcdef', :depth), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)
  end

  def test_simple_apply_dabcef
    assert(@nfa_simple.matches?('dabcef'), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)

    assert(@nfa_simple.matches?('dabcef', :depth), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)
  end

  def test_simple_apply_dbabc
    assert(@nfa_simple.matches?('dbabc'), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)

    assert(@nfa_simple.matches?('dbabc', :depth), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)
  end

  def test_simple_apply_alternation_abd
    @nfa_alternation = NFA.from_string('a(b|c)d')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('abd'), "NFA cannot match \"abd\"")
    assert_equal(2, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('abd', :depth), "NFA cannot match \"abd\"")
    assert_equal(2, @nfa_alternation.end)
  end

  def test_simple_apply_alternation_acd
    @nfa_alternation = NFA.from_string('a(b|c)d')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('acd'), "NFA cannot match \"acd\"")
    assert_equal(2, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('acd', :depth), "NFA cannot match \"acd\"")
    assert_equal(2, @nfa_alternation.end)
  end

  def test_simple_apply_alternation_ab
    @nfa_alternation = NFA.from_string('ab|cd')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('ab'), "NFA cannot match \"ab\"")
    assert_equal(1, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('ab', :depth), "NFA cannot match \"ab\"")
    assert_equal(1, @nfa_alternation.end)
  end

  def test_simple_apply_alternation_cd
    @nfa_alternation = NFA.from_string('ab|cd')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('cd'), "NFA cannot match \"cd\"")
    assert_equal(1, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('cd', :depth), "NFA cannot match \"cd\"")
    assert_equal(1, @nfa_alternation.end)
  end

  def test_longest
    @nfa_alternation = NFA.from_string('long|longest')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('longest'), "NFA cannot match \"longest\"")
    assert_equal(6, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('longest', :depth), "NFA cannot match \"longest\"")
    assert_equal(3, @nfa_alternation.end)
  end
end
