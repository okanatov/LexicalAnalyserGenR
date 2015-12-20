require 'stringio'
require_relative './syntax_tree'

# Creates an NFA from a string passed in the constructor
# and checks whether the NFA matches a given string.
class NFA
  attr_reader :label, :neigbours, :end, :empty_transitions

  def self.from_string(string)
    tree = SyntaxTree.new(StringIO.new(string))
    node = tree.expr

    from_syntax_tree(node)
  end

  def self.from_syntax_tree(node)
    if node.left.nil? && node.right.nil?
      return create_signle_expression_from(node.data)
    end

    left = from_syntax_tree(node.left)
    right = from_syntax_tree(node.right)

    if node.data == '.'
      left_end = left

      until left_end.empty_transitions.empty? && left_end.neigbours.empty?
        left_end = left_end.neigbours[left_end.neigbours.keys.first]
        if left_end.neigbours.empty?
          if !left_end.empty_transitions.empty?
            left_end = left_end.empty_transitions[0]
          end
        end
      end

      left_end.add_empty(right)

      return left
    end
  end

  def initialize(label)
    @label = label
    @neigbours = {}
    @empty_transitions = []
    @old_states = []
    @new_states = []
  end

  def add_neigbour(move_label, state)
    @neigbours[move_label] = state
  end

  def add_empty(state)
    @empty_transitions << state
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
    @end = 0
    @old_states.push(self)

    string.each_char do |char|
      @old_states.each do |old|
        state = move(old, char)
        add_state(state) unless @new_states.include? state
      end
      @old_states = @new_states.clone
      @new_states.clear

      @old_states.each do |old|
        return true if old.final?
      end
      @end += 1
    end
    @end = 0
    false
  end

  def matches_bt(string)
    @found = false
    @end = -1
    (0..string.length).each do |i|
      bt(self, string[i..string.length])
      break if @found
      @end += 1
    end
    @found
  end

  def max_path
    path = max_path = []
    find_max_path(path, max_path)
  end

  def to_s
    "State: label=#{@label}, neigbours=#{@neigbours}, empty_transitions=#{@empty_transitions}"
  end

  protected

  def final?
    neigbours.empty? && empty_transitions.empty?
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

  def add_state(state)
    @new_states.push state
    state.empty_transitions.each do |transition|
      add_state(transition) unless @new_states.include? transition
    end
  end

  def bt(state, string)
    return if reject(state, string)
    if accept(state)
      @found = true
      return
    end

    s = first(state, string)
    s.each do |key|
      bt(state.neigbours[key], string[1..string.length])
      @end += 1
      break if @found
    end

    state.empty_transitions.each do |transition|
      bt(transition, string[0..string.length])
      break if @found
    end
  end

  def reject(state, string)
    if state.final? || (state.neigbours.key? string[0..0]) || !state.empty_transitions.empty?
      return false
    else
      return true
    end
  end

  def accept(state)
    state.final?
  end

  def first(state, string)
    state.neigbours.keys.select { |i| i == string[0..0] }
  end

  def self.create_signle_expression_from(char)
    start = NFA.new("i#{char}")
    finish = NFA.new("f#{char}")
    start.add_neigbour(char, finish)

    start
  end

  def move(state, char)
    if state.neigbours.key? char
      return state.neigbours[char]
    elsif !state.empty_transitions.empty?
      return state.empty_transitions[0]
    else
      return self # TODO: what to return?
    end
  end
end
