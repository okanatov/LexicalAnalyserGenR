require 'stringio'
require_relative './nfa'
require_relative './rules_reader'

class Lexer
  def initialize(io)
    reader = RulesReader.new(io)
    @rule = reader.read
    @nfa = NFA.from_string(@rule[0])
  end

  def get_next_token(stringio)
    save_pos = stringio.pos

    found = @nfa.matches?(stringio)
    stringio.pos = save_pos

    if found
      stringio.pos = save_pos + @nfa.size
      eval(@rule[1])
    else
      stringio.pos = save_pos
      stringio.getc
    end
  end
end
