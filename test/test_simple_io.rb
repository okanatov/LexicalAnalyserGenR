require 'minitest/autorun'
require 'stringio'
require_relative '../lib/parser'

class SimpleIO < MiniTest::Test
    def test_simpleIO_empty
        parser = Parser.new(StringIO.new(""))
        assert_equal(0, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_I
        parser = Parser.new(StringIO.new("I"))
        assert_equal(1, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_II
        parser = Parser.new(StringIO.new("II"))
        assert_equal(2, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_III
        parser = Parser.new(StringIO.new("III"))
        assert_equal(3, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_IIII
        parser = Parser.new(StringIO.new("IIII"))
        assert_raises RuntimeError do
            parser.parse
        end
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_IV
        parser = Parser.new(StringIO.new("IV"))
        assert_equal(4, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_IVI
        parser = Parser.new(StringIO.new("IVI"))
        assert_raises RuntimeError do
            parser.parse
        end
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_V
        parser = Parser.new(StringIO.new("V"))
        assert_equal(5, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_VIV
        parser = Parser.new(StringIO.new("VIV"))
        assert_raises RuntimeError do
            parser.parse
        end
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_VII
        parser = Parser.new(StringIO.new("VII"))
        assert_equal(7, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_VIII
        parser = Parser.new(StringIO.new("VIII"))
        assert_equal(8, parser.parse)
        assert_equal(:finish, parser.state)
    end

    def test_simpleIO_VIIII
        parser = Parser.new(StringIO.new("VIIII"))
        assert_raises RuntimeError do
            parser.parse
        end
        assert_equal(:finish, parser.state)
    end
end
