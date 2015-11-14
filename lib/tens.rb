class Tens
    def getOne
        'X'
    end

    def getFive
        'L'
    end

    def getTen
        'C'
    end

    def isEnd(char)
        return char != getOne && char != getFive && char != getTen
    end
end
