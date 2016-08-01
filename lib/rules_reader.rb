# Author::     Oleg Kanatov  (mailto:okanatov@gmail.com)
# Copyright::  Copyright (c) 2015, 2016
# License::    Distributes under the same terms as Ruby

# Represents a rules reader
class RulesReader
  def initialize(io)
    @io = io
  end

  def read
    rule = @io.gets
    return nil unless rule

    state = :pattern
    pattern = action = ''

    rule.each_char do |char|
      state, pattern_char, action_char = step(state, char)
      pattern += pattern_char
      action += action_char
    end

    [pattern.chomp, action.chomp.strip]
  end

  private

  def step(state, char)
    pattern = action = ''

    return [:action, pattern, action] if char == '{' || char == '}'

    if state == :pattern
      pattern = char unless char =~ /[[:cntrl:]]/
    elsif state == :action
      action = char
    end

    [state, pattern, action]
  end
end
