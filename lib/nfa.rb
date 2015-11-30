class NFA
    attr_reader :label, :neigbours

    def NFA.from_string(string)
        expressions = create_expressions_from(string)
        return nil if expressions.empty?
        return create_nfa_from(expressions)
    end

    def initialize(label)
        @label = label
        @neigbours = Hash.new
        @old_states = Array.new
        @new_states = Array.new
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

    def matches(string)
        @old_states.push(self)

        string.each_char do |char|
            @old_states.each do |old|
                state = move(old, char)
                if not @new_states.include?(state)
                    @new_states.push(state)
                end
                @old_states.delete(old)
            end
            @old_states = @new_states.clone
            @new_states.clear

            @old_states.each do |old|
                if old.final?
                    return true
                end
            end
        end

        return false
    end

    def max_path
        path = max_path = Array.new
        self.find_max_path(path, max_path)
    end

    def to_s
        "State: label=#{@label}, neigbours=#{@neigbours}"
    end

    protected

    def final?
        return self.neigbours.empty?
    end

    def find_max_path(path, max_path)
        path << self.label
        if self.final?
            if max_path.length < path.length
                max_path = path.clone
            end

            return max_path
        else
            self.neigbours.keys.each do |key|
                max_path = self.neigbours[key].find_max_path(path.clone, max_path)
            end

            return max_path
        end
    end

    private

    def NFA.create_expressions_from(string)
        expressions = Array.new

        string.each_char do |char|
            expressions << create_signle_expression_from(char)
        end

        return expressions
    end

    def NFA.create_signle_expression_from(char)
        start = NFA.new("i#{char}")
        finish = NFA.new("f#{char}")
        start.add_neigbour(char, finish)

        return start
    end

    def NFA.create_nfa_from(expressions)
        nfa = expressions.shift
        state = nfa.neigbours[nfa.neigbours.keys.first]

        while not expressions.empty?
            elem = expressions.shift

            elem.neigbours.keys.each do |key|
                state.neigbours[key] = elem.neigbours[key]
            end

            state = state.neigbours[state.neigbours.keys.first]
        end

        return nfa
    end

    def move(state, char)
        if state.neigbours.has_key? char
            return state.neigbours[char]
        else
            return self # TODO: what to do here?
        end
    end
end
