require 'stringio'
require_relative './parser/ones'
require_relative './parser/tens'
require_relative './parser/start'
require_relative './parser/nextafteri'
require_relative './parser/finish'

module RomanNumbers
  # Represents a hard-code parser of Romans numbers
  class Parser
    attr_accessor :state

    def parse(string_to_parse)
      @string_io = StringIO.new(string_to_parse)

      @state = Start.new
      @result = 0
      tens = go_next(Tens.new)

      @state = Start.new
      @result = 0
      ones = go_next(Ones.new)

      10 * tens + ones
    end

    private

    def go_next(number)
      loop do
        @result += @state.go_next(self, number, @string_io, @result)
        break if @state.instance_of?(Finish)
      end
      @result
    end
  end
end
