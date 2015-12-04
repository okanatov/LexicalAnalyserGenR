class Tree
    def initialize(string)
        parse(string)
    end

    def parse(string)
        expression(string)
    end

    def expression(string)
        lpart = sym(string)
        eq = string.getc
        rpart = right_part(string)
        p eq
        p lpart
    end

    def right_part(string)
        op1 = sym(string)
        operator = sym(string)
        op2 = sym(string)
        p operator
        p op1
        p op2
    end

    def sym(string)
        return string.getc
    end

end
