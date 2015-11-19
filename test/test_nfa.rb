require 'minitest/autorun'
require_relative '../lib/nfa'

class SimpleNFA < MiniTest::Test
    def test_simple_nfa_creation
        nfa = NFA.new("abab")
        assert(nil != nfa.nfa)
    end

    def test_empty_nfa_creation
        nfa = NFA.new("")
        assert_nil(nfa.nfa)
    end

    def test_simple_automata_states
        nfa = NFA.new("abab")
        automata = nfa.nfa

        states = ['ia', 'fa', 'fb', 'fa', 'fb']

        i = 0
        automata.each do |elem|
            assert_equal(states[i], elem.label)
            i += 1
        end
    end

    def test_find_max_path
        nfa = NFA.new("abab")
        automata = nfa.nfa

        states = ['ia', 'fa', 'fb', 'fa', 'fb']
        assert_equal(states, automata.find_max_path)
    end

    def test_find_max_path_another
        nfa = NFA.new("abab")
        automata = nfa.nfa

        states = ['ia', 'fa', 'fb', 'fa', 'fb']
        max, max_path = automata.find_max

        assert_equal(states.length, max)
        assert_equal(states, max_path)
    end
end
