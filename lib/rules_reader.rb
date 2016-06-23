# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# Represents a rules reader
class RulesReader
  def initialize(file)
    @file = File.new(file)
  end

  def read
    rule = @file.gets.chop.split(/\t/)

    # Replace the second element with Proc obj
    code = rule[1].slice(1..-2)
    rule[1] = Proc.new { eval(code) }

    rule
  end
end
