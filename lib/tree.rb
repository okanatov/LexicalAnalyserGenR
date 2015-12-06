class Tree
    def initialize(string)
        @string = string
        @lookahead = @string.getc
        while @lookahead =~ /[[:blank:]]/
            @lookahead = @string.getc
        end
    end

    def parse()
        expr()
    end

    def expr()
        result = term()
        while true do
            if @lookahead == '+'
                match('+')
                result += term()
            elsif @lookahead == '-'
                match('-')
                result -= term()
            else
                break
            end
        end
        return result
    end

    def term()
        result = factor()
        while true do
            if @lookahead == '*'
                match('*')
                result *= factor()
            elsif @lookahead == '/'
                match('/')
                result /= term()
            else
                break
            end
        end
        return result
    end

    def factor()
        if @lookahead =~ /[[:digit:]]/
            temp = @lookahead
            match(@lookahead)
            return temp.to_i
        else
            raise IOError
        end
    end

    def match(char)
        if @lookahead == char
            @lookahead = @string.getc
            while @lookahead =~ /[[:blank:]]/
                @lookahead = @string.getc
            end
        else
            raise IOError
        end
    end
end
