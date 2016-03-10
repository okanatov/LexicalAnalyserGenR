require_relative './finish'

module RomanNumbers
  class NextAfterDoubleI
    def go_next(context, number, strio)
      result = 0
      char = strio.getc
      if char == number.one
        result = 1
        char = strio.getc
      end
      strio.ungetc(char)
      context.state = Finish.new
      result
    end
  end
end
