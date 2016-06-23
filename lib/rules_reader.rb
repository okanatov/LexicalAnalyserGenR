# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# Represents a rules reader
class RulesReader
  def initialize(file)
    @file = File.new(file)
  end

  def read
    rule = @file.gets
    return nil if not rule

    state = :pattern
    pattern = ""
    action = ""

    rule.each_char do |char|
      if char == '{'
        state = :action
        next
      end

      break if char == '}'

      if state == :pattern
        next if char =~ /[[:cntrl:]]/
        pattern += char
      elsif state == :action
        action += char
      end
    end

    # Replace action with Proc obj
    action = Proc.new { eval(action) }

    [pattern, action]
  end
end
