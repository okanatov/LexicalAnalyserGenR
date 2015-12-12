# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA
  attr_reader :label, :neigbours

  def self.from_string(string)
    expressions = create_expressions_from(string)
    return nil if expressions.empty?
    create_nfa_from(expressions)
  end

  def initialize(label)
    @label = label
    @neigbours = {}
    @old_states = []
    @new_states = []
  end

  def add_neigbour(move_label, state)
    @neigbours[move_label] = state
  end

  def each(&block)
    return self unless block_given?

    if neigbours.empty?
      block.call self
      return
    end

    block.call self

    neigbours.keys.each do |key|
      neigbours[key].each(&block)
    end
  end

  def matches(string)
    @old_states.push(self)

    string.each_char do |char|
      @old_states.each do |old|
        state = move(old, char)
        @new_states.push(state) unless @new_states.include?(state)
        @old_states.delete(old)
      end
      @old_states = @new_states.clone
      @new_states.clear

      @old_states.each do |old|
        return true if old.final?
      end
    end

    false
  end

  def max_path
    path = max_path = []
    find_max_path(path, max_path)
  end

  def to_s
    "State: label=#{@label}, neigbours=#{@neigbours}"
  end

  protected

  def final?
    neigbours.empty?
  end

  def find_max_path(path, max_path)
    path << label
    if self.final?
      max_path = path.clone if max_path.length < path.length

      return max_path
    else
      neigbours.keys.each do |key|
        max_path = neigbours[key].find_max_path(path.clone, max_path)
      end

      return max_path
    end
  end

  private

  def self.create_expressions_from(string)
    expressions = []

    string.each_char do |char|
      expressions << create_signle_expression_from(char)
    end

    expressions
  end

  def self.create_signle_expression_from(char)
    start = NFA.new("i#{char}")
    finish = NFA.new("f#{char}")
    start.add_neigbour(char, finish)

    start
  end

  def self.create_nfa_from(expressions)
    nfa = expressions.shift
    state = nfa.neigbours[nfa.neigbours.keys.first]

    until expressions.empty?
      elem = expressions.shift

      elem.neigbours.keys.each do |key|
        state.neigbours[key] = elem.neigbours[key]
      end

      state = state.neigbours[state.neigbours.keys.first]
    end

    nfa
  end

  def move(state, char)
    if state.neigbours.key? char
      return state.neigbours[char]
    else
      return self # TODO: what to do here?
    end
  end
end
