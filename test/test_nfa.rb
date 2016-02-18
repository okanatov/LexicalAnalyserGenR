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
    #@nfa_simple = NFA.from_string('abc')
    #assert(nil != @nfa_simple)
  end

  def test_simple_apply_abcdef
    skip
    assert(@nfa_simple.matches?('abcdef'), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)

    assert(@nfa_simple.matches?('abcdef', :depth), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)
  end

  def test_simple_apply_dabcef
    skip
    assert(@nfa_simple.matches?('dabcef'), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)

    assert(@nfa_simple.matches?('dabcef', :depth), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)
  end

  def test_simple_apply_dbabc
    skip
    assert(@nfa_simple.matches?('dbabc'), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)

    assert(@nfa_simple.matches?('dbabc', :depth), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)
  end

  def test_simple_apply_alternation_abd
    skip
    @nfa_alternation = NFA.from_string('a(b|c)d')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('abd'), "NFA cannot match \"abd\"")
    assert_equal(2, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('abd', :depth), "NFA cannot match \"abd\"")
    assert_equal(2, @nfa_alternation.end)
  end

  def test_simple_apply_alternation_acd
    skip
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
    skip
    @nfa_alternation = NFA.from_string('ab|cd')
    assert(nil != @nfa_alternation)

    assert(@nfa_alternation.matches?('cd'), "NFA cannot match \"cd\"")
    assert_equal(1, @nfa_alternation.end)

    assert(@nfa_alternation.matches?('cd', :depth), "NFA cannot match \"cd\"")
    assert_equal(1, @nfa_alternation.end)
  end

  def test_max_path
    skip
    assert_equal(%w(a b c), @nfa_simple.max_path)
  end
end
