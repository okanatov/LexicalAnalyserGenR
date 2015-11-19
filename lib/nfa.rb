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

    def each
        return self if not block_given?

        state = self
        loop do
            yield state
            state.neigbours.keys.each do |key|
                state = state.neigbours[key]
                state.each do |elem|
                    elem
                end
            end
            break if state.neigbours.empty?
        end
        yield state
    end

    def find_max_path
        num = max = 0
        path = max_path = Array.new

        self.each { |e|
            num += 1
            path << e.label
            if max < num
                max = num
                max_path = path.clone
            end
        }

        return max_path
    end

    def find_max
        num = max = 0
        path = max_path = Array.new
        max, max_path = find_max2(num, max, path, max_path)
        return max, max_path
    end

    def find_max2(num, max, path, max_path)
        state = self
        num += 1
        path << state.label
        loop do
            state.neigbours.keys.each do |key|
                state = state.neigbours[key]
                max, max_path = state.find_max2(num, max, path, max_path)
            end
            break if state.neigbours.empty?
        end
        if max < num
            max = num
            max_path = path.clone
        end
        return max, max_path
    end

    def to_s
        "State: label=#{@label}, neigbours=#{@neigbours}"
    end
end
