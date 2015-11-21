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
        state = @nfa.neigbours[@nfa.neigbours.keys.first]

        while not expressions.empty?
            elem = expressions.shift

            elem.neigbours.keys.each do |key|
                state.neigbours[key] =
                    elem.neigbours[key]
            end

            state = state.neigbours[state.neigbours.keys.first]
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

    def each(&block)
        return self if not block_given?

        if self.neigbours.empty?
            block.call self
            return
        end

        block.call self

        self.neigbours.keys.each do |key|
            self.neigbours[key].each(&block)
        end
    end

    def max_path
        path = max_path = Array.new
        state = self

        find_max_path(path, max_path, state)
    end

    def to_s
        "State: label=#{@label}, neigbours=#{@neigbours}"
    end

    private
    def find_max_path(path, max_path, state)
        path << state.label
        if state.neigbours.empty?
            if max_path.length < path.length
                max_path = path.clone
            end

            return max_path
        end

        state.neigbours.keys.each do |key|
            max_path = find_max_path(path.clone, max_path, state.neigbours[key])
        end

        return max_path
    end
end
