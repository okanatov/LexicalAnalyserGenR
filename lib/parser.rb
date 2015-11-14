class Parser
    attr_reader :state

    def initialize(string_to_parse)
        @string_io = string_to_parse
        @state = :start
        @result = 0
    end

    def parse
        loop do
            char = @string_io.getc
            case @state
            when :start
                if char == 'I'
                    @result += 1
                    @state = :nextAfterI
                elsif char == 'V'
                    @result += 5
                    @state = :nextAfterV
                else
                    @string_io.ungetc(char)
                    @state = :finish
                end
            when :nextAfterI
                if char == 'I'
                    @result += 1
                    @state = :nextAfterDoubleI
                elsif char == 'V'
                    @result += 3
                    @state = :finish
                else
                    @string_io.ungetc(char)
                    @state = :finish
                end
            when :nextAfterDoubleI
                if char == 'I'
                    @result += 1
                else
                    @string_io.ungetc(char)
                end
                @state = :finish
            when :nextAfterV
                if char == 'I'
                    @result += 1
                    @state = :nextAfterVI
                else
                    @string_io.ungetc(char)
                    @state = :finish
                end
            when :nextAfterVI
                if char == 'I'
                    @result += 1
                    @state = :nextAfterDoubleI
                else
                    @string_io.ungetc(char)
                    @state = :finish
                end
            when :finish
                if char != nil
                    raise RuntimeError, "spare characters"
                end
                break
            else
                raise RuntimeError, "not reachable statement"
            end
        end
        @result
    end
end
