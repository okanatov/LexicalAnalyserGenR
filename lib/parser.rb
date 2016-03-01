require_relative 'ones'
require_relative 'tens'

# Represent a hard-code parser of Romans numbers
class Parser
  attr_reader :state

  def initialize(string_to_parse)
    @string_io = string_to_parse
    @state = :start
  end

  def parse
    tens = step(Tens.new)
    @state = :start
    ones = step(Ones.new)

    10 * tens + ones
  end

  private

  def step(number)
    result = 0
    char = @string_io.getc
    loop do
      case @state
      when :start
        if char == number.one
          result += 1
          @state = :nextAfterI
        elsif char == number.five
          result += 5
          @state = :nextAfterV
        else
          @state = :finish
        end
      when :nextAfterI
        char = @string_io.getc
        if char == number.one
          result += 1
          @state = :nextAfterDoubleI
        elsif char == number.five
          result += 3
          char = @string_io.getc
          @state = :finish
        elsif char == number.ten
          result += 8
          char = @string_io.getc
          @state = :finish
        else
          @state = :finish
        end
      when :nextAfterDoubleI
        char = @string_io.getc
        if char == number.one
          result += 1
          char = @string_io.getc
        end
        @state = :finish
      when :nextAfterV
        char = @string_io.getc
        if char == number.one
          result += 1
          @state = :nextAfterVI
        else
          @state = :finish
        end
      when :nextAfterVI
        char = @string_io.getc
        if char == number.one
          result += 1
          @state = :nextAfterDoubleI
        else
          @state = :finish
        end
      when :finish
        raise 'spare characters' unless number.end?(char)
        @string_io.ungetc(char) unless char.nil?
        break
      else
        raise 'not reachable statement'
      end
    end
    result
  end
end
