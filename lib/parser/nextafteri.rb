module RomanNumbers
  class NextAfterI
    def go_next(context, _number, strio, _result)
      char = strio.getc
      strio.ungetc(char)
      context.state = Finish.new
      0
    end
  end
end
