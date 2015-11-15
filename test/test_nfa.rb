require 'minitest/autorun'
require_relative '../lib/nfa'

class SimpleNFA < MiniTest::Test
    def setup
        @nfa = NFA.new("abab")
    end

    def test_simpleGet
        assert_equal('a', @nfa.get)
        assert_equal('b', @nfa.get)
        assert_equal('a', @nfa.get)
        assert_equal('b', @nfa.get)
        assert_equal(nil, @nfa.get)
    end

    def test_simpleCreateNFA
        @nfa.createFullNFA
    end
end
