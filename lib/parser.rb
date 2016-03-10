require 'stringio'
require_relative './parser/ones'
require_relative './parser/tens'
require_relative './parser/start'
require_relative './parser/finish'

module RomanNumbers
  # Represents a hard-code parser of Romans numbers
  class Parser
    attr_accessor :state

    def parse(string_to_parse)
      @string_io = StringIO.new(string_to_parse)

      @state = Start.new
      tens = go_next(Tens.new)

      @state = Start.new
      ones = go_next(Ones.new)

      10 * tens + ones
    end

    private

    def go_next(number)
      result = 0
      loop do
        begin
          result += @state.go_next(self, number, @string_io)
        rescue
          raise 'spare characters'
        end
        break if @state.instance_of?(Start)
      end
      result
    end
  end
end
