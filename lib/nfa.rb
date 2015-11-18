class NFA
    def initialize(string)
        @string = string
        @nfa = nil
    end

    def nfa
        expressions = Array.new
        handle_input_string(expressions)

        return nil if expressions.empty?

        create_nfa_from(expressions)

        return @nfa
    end

    private
    def handle_input_string(expressions)
        @string.each_char do |char|
            expressions << create_single_expression_from(char)
        end
    end

    def create_single_expression_from(char)
        start = State.new("i#{char}")
        finish = State.new("f#{char}")
        start.add_neigbour(char, finish)

        return start
    end

    def create_nfa_from(expressions)
        @nfa = expressions.shift

        while not expressions.empty?
            state = @nfa.last
            elem = expressions.shift

            state.neigbours[elem.neigbours.keys.first] =
                elem.neigbours[elem.neigbours.keys.first]
        end
    end
end

class State
    attr_reader :label, :neigbours

    def initialize(label)
        @label = label
        @neigbours = Hash.new
    end

    def add_neigbour(move_label, state)
        @neigbours[move_label] = state
    end

    def each
        return self if not block_given?

        state = self
        loop do
            yield state
            state.neigbours.keys.each do |key|
                state = state.neigbours[key]
            end
            break if state.neigbours.empty?
        end
        yield state
    end

    def last
        state = self
        loop do
            state.neigbours.keys.each do |key|
                state = state.neigbours[key]
            end
            break if state.neigbours.empty?
        end
        return state
    end

    def to_s
        "State: label=#{@label}, neigbours=#{@neigbours}"
    end
end
