require 'stringio'
require_relative './nfa'

class Lexer
  def initialize(string)
     @nfa = NFA.from_string(string)
  end

  def get_next_token(stringio)
    save_pos = stringio.pos

    found = @nfa.matches?(stringio)
    stringio.pos = save_pos

    return stringio.read(@nfa.size) if found
    stringio.getc
  end
end
