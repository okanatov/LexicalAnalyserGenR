class Node
    attr_reader :data, :left, :right

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
        traversal(@tree)
    end

    private

    def traversal(node)
        return puts node if node.left == nil and node.right == nil
        left = traversal(node.left)
        right = traversal(node.right)
        
        if node.data == '+'
            puts "+ Left=#{node.left}, Right=#{node.right}"
        elsif node.data == '*'
            puts "* Left=#{node.left}, Right=#{node.right}"
        elsif node.data == 'c'
            puts "c Left=#{node.left}, Right=#{node.right}"
        end
    end

    # E = term R
    # R = + term R | * term R | e
    # term = id | (E)

    def expr()
        left = term()
        while true
            if @lookahead == '+'
                match('+')
                right = term()
                left = plus_method(left, right)
            elsif @lookahead == '*'
                match('*')
                right = term()
                left = star_method(left, right)
            elsif @lookahead =~ /[[:digit:]]/
                right = term()
                left = concat_method(left, right)
            else
                break
            end
        end

        return left
    end

    def term()
        if @lookahead =~ /[[:digit:]]/
            node = Node.new(@lookahead, nil, nil)
            match(@lookahead)
            return node
        elsif @lookahead == '('
            match('(')
            temp = expr()
            match(')')
            return temp
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

    def plus_method(left, right)
        return Node.new("+", left, right)
    end

    def star_method(left, right)
        return Node.new("*", left, right)
    end

    def concat_method(left, right)
        return Node.new("c", left, right)
    end
end
