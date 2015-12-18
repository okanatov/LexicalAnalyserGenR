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
end
