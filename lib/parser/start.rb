require_relative './ones'
require_relative './tens'

module RomanNumbers
  class Start
    def go_next(context, number, strio, result)
      char = strio.getc
      result = 0
      if char == number.one
        result += 1
        context.state = NextAfterI.new
      else
        strio.ungetc(char)
        context.state = Finish.new
      end
      result
    end
  end
end
