class NFA
    def initialize(string)
        @string = string
        @nfa = Array.new
    end

    def createNFA
        @string.each_char do |c|
            @nfa << createSimpleExpression(c)
        end

        joinSimpleExpressions
        
        # puts @nfa[0] # to leave only 1 element

        state = @nfa[0]
        while (state.neigbours.length != 0)
            puts state.label

            transition = state.neigbours.keys.first
            state = state.neigbours[transition]
        end
        puts state.label
    end

    private
    def createSimpleExpression(char)
        start = State.new
        finish = State.new

        start.label = "i#{char}"
        finish.label = "f#{char}"

        start.neigbours[char] = finish

        return start
    end

    def joinSimpleExpressions
        @nfa.each_index do |i|
            next if i == 0
            prev = @nfa[i - 1]
            curr = @nfa[i]

            transition = prev.neigbours.keys.first

            prev.neigbours[transition] = curr
        end
    end
end

class State
    attr_accessor :label, :neigbours

    def initialize
        @neigbours = Hash.new
    end

    def to_s
        "State: label=#{@label}, neigbours=#{@neigbours}"
    end
end
