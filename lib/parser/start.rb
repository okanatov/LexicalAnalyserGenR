require_relative './nextafteri'
require_relative './nextafterv'
require_relative './finish'
require_relative './ones'
require_relative './tens'

module RomanNumbers
  class Start
    def go_next(context, number, strio)
      char = strio.getc
      result = 0
      if char == number.one
        result = 1
        context.state = NextAfterI.new
      elsif char == number.five
        result = 5
        context.state = NextAfterV.new
      else
        strio.ungetc(char)
        context.state = Finish.new
      end
      result
    end
  end
end
