class Node
    attr_reader :left, :right

    def initialize(data, left, right)
        @data = data
        @left = left
        @right = right
    end

    def to_s
        "Node: data=#{@data}, left=#{@left}, right=#{@right}"
    end
end

class Tree
    def initialize(string)
        @string = string
        @lookahead = @string.getc

        while @lookahead =~ /[[:blank:]]/
            @lookahead = @string.getc
        end
    end

    def parse()
        @tree = expr()
        tree_print(@tree)
    end

    private

    def tree_print(node)
        if node == nil
            return
        end

        tree_print(node.left)
        puts node
        tree_print(node.right)
    end

    def expr()
        left = term()
        while true do
            if @lookahead == '+'
                match('+')
                right = term()

                left = Node.new('+', left, right)
            else
                break
            end
        end

        return left
    end

    def term()
        left = factor()
        while true do
            if @lookahead == '*'
                match('*')
                right = factor()

                left = Node.new('*', left, right)
            else
                break
            end
        end

        return left
    end

    def factor()
        if @lookahead =~ /[[:digit:]]/
            node = Node.new(@lookahead, nil, nil)
            match(@lookahead)

            return node
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
