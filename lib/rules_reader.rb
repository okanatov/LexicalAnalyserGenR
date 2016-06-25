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
      state, pattern_char, action_char = step(state, char)
      pattern += pattern_char
      action += action_char
    end

    pattern.chomp!
    action.chomp!.strip!

    [pattern, action]
  end

  private

  def step(state, char)
    pattern = ""
    action = ""

    return [:action, pattern, action] if char == '{' or char == '}'

    if state == :pattern
      pattern = char unless char =~ /[[:cntrl:]]/
    elsif state == :action
      action = char
    end

    return [state, pattern, action]
  end
end
