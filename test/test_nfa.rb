require 'minitest/autorun'
require_relative '../lib/nfa'

class SimpleNFA < MiniTest::Test
    def setup
        @nfa = NFA.new("abab")
    end

    def test_simple_nfa_creation
        assert(nil != @nfa.nfa)
    end
end
