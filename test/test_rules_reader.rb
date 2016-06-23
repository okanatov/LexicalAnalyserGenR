# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

require 'minitest/autorun'
require_relative '../lib/rules_reader'

# Tests for rules reader
class RulesReaderTest < MiniTest::Test
  def setup
    @reader = RulesReader.new('test/test_rules.txt')
  end

  # All rules consist of two fields; the first one is for the regex pattern and
  # the second one for the code block
  # Method RulesReader::read returns Array consisting of two elements; the first element
  # contains the pattern and the second one contains the Proc object
  def test_should_read_rules_from_file
    rule = @reader.read

    assert_equal('abc', rule[0])
    assert_instance_of(Proc, rule[1])

    rule[1].call
  end
end
