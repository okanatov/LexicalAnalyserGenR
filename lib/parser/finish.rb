require_relative './start'

module RomanNumbers
  class Finish
    def go_next(context, number, strio)
      char = strio.getc
      raise unless number.end?(char)
      strio.ungetc(char) unless char.nil?
      context.state = Start.new
      0
    end
  end
end
