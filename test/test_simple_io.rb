require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/parser'

# Verifies the Parser class
class SimpleIO < MiniTest::Test

  include RomanNumbers

  def test_simple_empty
    parser = Parser.new
    assert_equal(0, parser.parse(''))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_I
    parser = Parser.new
    assert_equal(1, parser.parse('I'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_II
    parser = Parser.new
    assert_equal(2, parser.parse('II'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_III
    parser = Parser.new
    assert_equal(3, parser.parse('III'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_IIII
    parser = Parser.new
    err = assert_raises RuntimeError do
      parser.parse('IIII')
    end
    assert_equal('spare characters', err.message)
    assert(parser.state.instance_of?(Finish))
  end

  def test_simple_IV
    parser = Parser.new
    assert_equal(4, parser.parse('IV'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_IVI
    parser = Parser.new
    err = assert_raises RuntimeError do
      parser.parse('IVI')
    end
    assert_equal('spare characters', err.message)
    assert(parser.state.instance_of?(Finish))
  end

  def test_simple_V
    parser = Parser.new
    assert_equal(5, parser.parse('V'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_VIV
    parser = Parser.new
    err = assert_raises RuntimeError do
      parser.parse('VIV')
    end
    assert_equal('spare characters', err.message)
    assert(parser.state.instance_of?(Finish))
  end

  def test_simple_VII
    parser = Parser.new
    assert_equal(7, parser.parse('VII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_VIII
    parser = Parser.new
    assert_equal(8, parser.parse('VIII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_VIIII
    parser = Parser.new
    err = assert_raises RuntimeError do
      parser.parse('VIIII')
    end
    assert_equal('spare characters', err.message)
    assert(parser.state.instance_of?(Finish))
  end

  def test_simple_G
    parser = Parser.new
    err = assert_raises RuntimeError do
      parser.parse('G')
    end
    assert_equal('spare characters', err.message)
    assert(parser.state.instance_of?(Finish))
  end

  def test_simple_IX
    parser = Parser.new
    assert_equal(9, parser.parse('IX'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_X
    parser = Parser.new
    assert_equal(10, parser.parse('X'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XI
    parser = Parser.new
    assert_equal(11, parser.parse('XI'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XII
    parser = Parser.new
    assert_equal(12, parser.parse('XII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XIII
    parser = Parser.new
    assert_equal(13, parser.parse('XIII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XIV
    parser = Parser.new
    assert_equal(14, parser.parse('XIV'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XV
    parser = Parser.new
    assert_equal(15, parser.parse('XV'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XVI
    parser = Parser.new
    assert_equal(16, parser.parse('XVI'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XVII
    parser = Parser.new
    assert_equal(17, parser.parse('XVII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XVIII
    parser = Parser.new
    assert_equal(18, parser.parse('XVIII'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XIX
    parser = Parser.new
    assert_equal(19, parser.parse('XIX'))
    assert(parser.state.instance_of?(Start))
  end

  def test_simple_XX
    parser = Parser.new
    assert_equal(20, parser.parse('XX'))
    assert(parser.state.instance_of?(Start))
  end
end
