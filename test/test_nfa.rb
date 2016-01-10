require 'simplecov'
if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter "test/"
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

  def test_simple_apply_abcdef
    assert(@nfa_simple.matches('abcdef'), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)
  end

  def test_bt_simple_apply_abcdef
    assert(@nfa_simple.matches_bt('abcdef'), "NFA cannot match \"abc\"")
    assert_equal(2, @nfa_simple.end)
  end

  def test_simple_apply_dabcef
    assert(@nfa_simple.matches('dabcef'), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)
  end

  def test_bt_simple_apply_dabcef
    assert(@nfa_simple.matches_bt('dabcef'), "NFA cannot match \"abc\"")
    assert_equal(3, @nfa_simple.end)
  end

  def test_simple_apply_dbabc
    assert(@nfa_simple.matches('dbabc'), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)
  end

  def test_bt_simple_apply_dabc
    assert(@nfa_simple.matches_bt('dbabc'), "NFA cannot match \"abc\"")
    assert_equal(4, @nfa_simple.end)
  end

  def test_max_path
    assert_equal(%w(a b c), @nfa_simple.max_path)
  end
end
