require 'minitest/autorun'
require_relative '../lib/nfa'

# Verifies the NFA class
class SimpleNFA < MiniTest::Test
  def setup
    @nfa_simple = NFA.from_string('abab')
    assert(nil != @nfa_simple)

    @nfa_empty = NFA.from_string('')
    assert_nil(@nfa_empty)

    a = NFA.new('a')
    assert(nil != a)

    b = NFA.new('b')
    c = NFA.new('c')
    d = NFA.new('d')
    e = NFA.new('e')

    d.add_neigbour('e', e)
    b.add_neigbour('c', c)
    b.add_neigbour('d', d)
    a.add_neigbour('b', b)

    @nfa_complex = a
  end

  def test_simple_automata_states
    i = 0
    states = %w(ia fa fb fa fb)

    @nfa_simple.each do |elem|
      assert_equal(states[i], elem.label)
      i += 1
    end
  end

  def test_complex_max_path
    max_path = @nfa_complex.max_path
    states = %w(a b d e)
    assert_equal(states, max_path)
  end

  def test_simple_apply_abab
    assert(@nfa_simple.matches('abab'), "NFA cannot match \"abab\"")
  end

  def test_simple_not_apply_abba
    assert(!@nfa_simple.matches('abba'), "NFA can match \"abba\"")
  end

  def test_simple_apply_cababd
    assert(@nfa_simple.matches('cababd'), "NFA cannot match \"cababd\"")
  end

  def test_complex_apply_abde
    assert(@nfa_complex.matches('abde'), "NFA cannot match \"abde\"")
  end

  def test_complex_not_apply_acde
    assert(!@nfa_complex.matches('acde'), "NFA can match \"acde\"")
  end

  def test_complex_apply_cabcd
    assert(@nfa_complex.matches('cabcd'), "NFA cannot match \"cabcd\"")
  end

  def test_complex_not_apply_ababec
    assert(!@nfa_complex.matches('ababec'), "NFA can match \"ababec\"")
  end

  def test_complex_apply_ababce
    assert(@nfa_complex.matches('ababce'), "NFA cannot match \"ababce\"")
  end

  def test_bt_simple_apply_abab
    assert(@nfa_simple.matches_bt('abab'), "NFA cannot match \"abab\"")
  end

  def test_bt_simple_not_apply_abba
    assert(!@nfa_simple.matches_bt('abba'), "NFA can match \"abba\"")
  end

  def test_bt_simple_apply_cababd
    assert(@nfa_simple.matches_bt('cababd'), "NFA cannot match \"cababd\"")
  end

  def test_bt_complex_apply_abde
    assert(@nfa_complex.matches_bt('abde'), "NFA cannot match \"abde\"")
  end

  def test_bt_complex_not_apply_acde
    assert(!@nfa_complex.matches_bt('acde'), "NFA can match \"acde\"")
  end

  def test_bt_complex_apply_cabcd
    assert(@nfa_complex.matches_bt('cabcd'), "NFA cannot match \"cabcd\"")
  end

  def test_bt_complex_not_apply_ababec
    assert(!@nfa_complex.matches_bt('ababec'), "NFA can match \"ababec\"")
  end

  def test_bt_complex_apply_ababce
    assert(@nfa_complex.matches_bt('ababce'), "NFA cannot match \"ababce\"")
  end
end
