module RomanNumbers
  # Represents Romans ten numbers
  class Tens
    def one
      'X'
    end

    def five
      'L'
    end

    def ten
      'C'
    end

    def end?(char)
      char != one && char != five && char != ten
    end
  end
end
