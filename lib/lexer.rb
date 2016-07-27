require 'stringio'
require_relative './nfa'
require_relative './rules_reader'

class Lexer
  def initialize(file)
    reader = RulesReader.new(file)
    rule = reader.read
    @nfa = NFA.from_string(rule[0])
  end

  def get_next_token(stringio)
    save_pos = stringio.pos

    found = @nfa.matches?(stringio)
    stringio.pos = save_pos

    return stringio.read(@nfa.size) if found
    stringio.getc
  end
end
