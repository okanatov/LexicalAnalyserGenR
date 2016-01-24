require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/parser'

# Verifies the Parser class
class SimpleIO < MiniTest::Test
  def test_simple_empty
    parser = Parser.new(StringIO.new(''))
    assert_equal(0, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_I
    parser = Parser.new(StringIO.new('I'))
    assert_equal(1, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_II
    parser = Parser.new(StringIO.new('II'))
    assert_equal(2, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_III
    parser = Parser.new(StringIO.new('III'))
    assert_equal(3, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_IIII
    parser = Parser.new(StringIO.new('IIII'))
    err = assert_raises RuntimeError do
      parser.parse
    end
    assert_equal('spare characters', err.message)
    assert_equal(:finish, parser.state)
  end

  def test_simple_IV
    parser = Parser.new(StringIO.new('IV'))
    assert_equal(4, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_IVI
    parser = Parser.new(StringIO.new('IVI'))
    err = assert_raises RuntimeError do
      parser.parse
    end
    assert_equal('spare characters', err.message)
    assert_equal(:finish, parser.state)
  end

  def test_simple_V
    parser = Parser.new(StringIO.new('V'))
    assert_equal(5, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_VIV
    parser = Parser.new(StringIO.new('VIV'))
    err = assert_raises RuntimeError do
      parser.parse
    end
    assert_equal('spare characters', err.message)
    assert_equal(:finish, parser.state)
  end

  def test_simple_VII
    parser = Parser.new(StringIO.new('VII'))
    assert_equal(7, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_VIII
    parser = Parser.new(StringIO.new('VIII'))
    assert_equal(8, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_VIIII
    parser = Parser.new(StringIO.new('VIIII'))
    err = assert_raises RuntimeError do
      parser.parse
    end
    assert_equal('spare characters', err.message)
    assert_equal(:finish, parser.state)
  end

  def test_simple_G
    parser = Parser.new(StringIO.new('G'))
    err = assert_raises RuntimeError do
      parser.parse
    end
    assert_equal('spare characters', err.message)
    assert_equal(:finish, parser.state)
  end

  def test_simple_IX
    parser = Parser.new(StringIO.new('IX'))
    assert_equal(9, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_X
    parser = Parser.new(StringIO.new('X'))
    assert_equal(10, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XI
    parser = Parser.new(StringIO.new('XI'))
    assert_equal(11, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XII
    parser = Parser.new(StringIO.new('XII'))
    assert_equal(12, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XIII
    parser = Parser.new(StringIO.new('XIII'))
    assert_equal(13, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XIV
    parser = Parser.new(StringIO.new('XIV'))
    assert_equal(14, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XV
    parser = Parser.new(StringIO.new('XV'))
    assert_equal(15, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XVI
    parser = Parser.new(StringIO.new('XVI'))
    assert_equal(16, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XVII
    parser = Parser.new(StringIO.new('XVII'))
    assert_equal(17, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XVIII
    parser = Parser.new(StringIO.new('XVIII'))
    assert_equal(18, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XIX
    parser = Parser.new(StringIO.new('XIX'))
    assert_equal(19, parser.parse)
    assert_equal(:finish, parser.state)
  end

  def test_simple_XX
    parser = Parser.new(StringIO.new('XX'))
    assert_equal(20, parser.parse)
    assert_equal(:finish, parser.state)
  end
end
