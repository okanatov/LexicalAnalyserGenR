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

    def test_simple_apply_abab
        automata = @nfa_simple.nfa
        assert(automata.matches("abab"), "The automata cannot match \"abab\"")
    end

    def test_simple_not_apply_abba
        automata = @nfa_simple.nfa
        assert(!automata.matches("abba"), "The automata can match \"abba\"")
    end

    def test_simple_apply_cababd
        automata = @nfa_simple.nfa
        assert(automata.matches("cababd"), "The automata cannot match \"cababd\"")
    end

    def test_complex_apply_abab
        assert(@nfa_complex.matches("abde"), "The automata cannot match \"abde\"")
    end

    def test_complex_not_apply_abba
        assert(!@nfa_complex.matches("acde"), "The automata can match \"abcde\"")
    end

    def test_complex_apply_cababd
        assert(@nfa_complex.matches("cabcd"), "The automata cannot match \"cabcd\"")
    end

    def test_complex_apply_works
        assert(!@nfa_complex.matches("ababec"), "The automata can match \"ababec\"")
    end
end
