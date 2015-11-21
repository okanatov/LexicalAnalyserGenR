require 'minitest/autorun'
require_relative '../lib/nfa'

class SimpleNFA < MiniTest::Test
    def setup
        @nfa_simple = NFA.new("abab")
        @nfa_empty = NFA.new("")

        a = State.new("a")
        b = State.new("b")
        c = State.new("c")
        d = State.new("d")
        e = State.new("e")


        d.add_neigbour("e", e)
        b.add_neigbour("c", c)
        b.add_neigbour("d", d)
        a.add_neigbour("b", b)

        @nfa_complex = a
    end

    def test_simple_nfa_creation
        assert(nil != @nfa_simple.nfa)
    end

    def test_empty_nfa_creation
        assert_nil(@nfa_empty.nfa)
    end

    def test_simple_automata_states
        automata = @nfa_simple.nfa

        states = ['ia', 'fa', 'fb', 'fa', 'fb']

        i = 0
        automata.each do |elem|
            assert_equal(states[i], elem.label)
            i += 1
        end
    end

    def test_complex_max_path
        max_path = @nfa_complex.max_path
        states = ['a', 'b', 'd', 'e']
        assert_equal(states, max_path)
    end
end
