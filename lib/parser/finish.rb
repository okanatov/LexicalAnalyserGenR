module RomanNumbers
  class Finish
    def go_next(_context, number, strio, _result)
      char = strio.getc
      raise 'spare characters' unless number.end?(char)
      strio.ungetc(char) unless char.nil?
      0
    end
  end
end
