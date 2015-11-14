require_relative 'ones'
require_relative 'tens'

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

        return 10 * tens + ones
    end

    def step(number)
        result = 0
        char = @string_io.getc
        loop do
            case @state
            when :start
                if char == number.getOne
                    result += 1
                    @state = :nextAfterI
                elsif char == number.getFive
                    result += 5
                    @state = :nextAfterV
                else
                    @state = :finish
                end
            when :nextAfterI
                char = @string_io.getc
                if char == number.getOne
                    result += 1
                    @state = :nextAfterDoubleI
                elsif char == number.getFive
                    result += 3
                    char = @string_io.getc
                    @state = :finish
                elsif char == number.getTen
                    result += 8
                    char = @string_io.getc
                    @state = :finish
                else
                    @state = :finish
                end
            when :nextAfterDoubleI
                char = @string_io.getc
                if char == number.getOne
                    result += 1
                    char = @string_io.getc
                end
                @state = :finish
            when :nextAfterV
                char = @string_io.getc
                if char == number.getOne
                    result += 1
                    @state = :nextAfterVI
                else
                    @state = :finish
                end
            when :nextAfterVI
                char = @string_io.getc
                if char == number.getOne
                    result += 1
                    @state = :nextAfterDoubleI
                else
                    @state = :finish
                end
            when :finish
                if !number.isEnd(char)
                    raise RuntimeError, "spare characters"
                elsif !char.nil?
                    @string_io.ungetc(char)
                end
                break
            else
                raise RuntimeError, "not reachable statement"
            end
        end
        return result
    end
end
