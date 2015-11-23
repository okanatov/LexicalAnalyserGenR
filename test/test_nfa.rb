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
        assert(automata.apply("abab"), "The automata cannot apply \"abab\"")
    end

    def test_simple_not_apply_abba
        automata = @nfa_simple.nfa
        assert(!automata.apply("abba"), "The automata can apply \"abba\"")
    end

    def test_simple_apply_cababd
        automata = @nfa_simple.nfa
        assert(automata.apply("cababd"), "The automata cannot apply \"cababd\"")
    end

    def test_complex_apply_abab
        assert(@nfa_complex.apply("abde"), "The automata cannot apply \"abde\"")
    end

    def test_complex_not_apply_abba
        assert(!@nfa_complex.apply("acde"), "The automata can apply \"abcde\"")
    end

    def test_complex_apply_cababd
        assert(@nfa_complex.apply("cabcd"), "The automata cannot apply \"cabcd\"")
    end

    def test_complex_apply_works
        assert(!@nfa_complex.apply("ababec"), "The automata can apply \"ababec\"")
    end
end
