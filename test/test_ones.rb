require 'minitest/autorun'
require_relative '../lib/ones'

class OnesTest < MiniTest::Test
    def setup
        @ones = Ones.new
    end

    def test_ones
        assert_equal('I', @ones.getOne)
    end

    def test_fives
        assert_equal('V', @ones.getFive)
    end

    def test_tens
        assert_equal('X', @ones.getTen)
    end

    def test_not_end
        assert(false == @ones.isEnd('a'))
    end

    def test_end
        assert(true == @ones.isEnd(nil))
    end
end
