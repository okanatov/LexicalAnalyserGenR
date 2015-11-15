class NFA
    def initialize(string)
        @string = string
        @index = 0
        @diagrams = Array.new
    end

    def get
        result = @string[@index]
        @index += 1
        result
    end

    def createFullNFA
        (0..@string.length - 1).each do
            createSimple
        end

        p @diagrams
    end

    private
    def createSimple
        char = get

        startState = State.new
        startState.label = "i#{char}"

        endState = State.new
        endState.label = "f#{char}"

        transition = Transition.new(startState, endState, char)
        @diagrams << transition
    end
end

class State
    attr_accessor :label

    def to_s
        "State: label=#{@label}"
    end
end

class Transition
    attr_reader :startState, :endState
    attr_reader :label

    def initialize(startState, endState, label)
        @startState = startState
        @endState = endState
        @label = label
    end

    def to_s
        "Transition: startState=#{@startState}, endState=#{@endState}, label=#{@label}"
    end
end
