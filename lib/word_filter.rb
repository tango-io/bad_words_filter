require "word_filter/version"

module WordFilter
  class WordFilter

    @@emailRegex = /[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\\.[a-zA-Z]{2,4}/
    @@alphaNumericDigit = /(zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|\d)/; 
    @@digitsRegex = Regexp.new("\b(\s*" + @@alphaNumericDigit.source + ")+\b")
    @@streetNameRegex = Regexp.new("\b(\s*" + @@alphaNumericDigit.source + ")+\s([a-z\d]+\.?\s*){1,5}\b(avenue|ave|street|st|court|ct|circle|boulevard|blvd|lane|ln|trail|tr|loop|lp|route|rt|drive|dr|road|rd|terrace|tr|way|wy|highway|hiway|hw)\b")
    @@phoneNumber = Regexp.new("((" + @@alphaNumericDigit.source + ")\W*?){3}((" + @@alphaNumericDigit.source + ")\W*?){4}\b")
    @@urlRegex = /(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/
    
   NONE = 0;
   REPEATED_VOWELS = 1;
   SWAPPABLE_VOWELS = 2;
   SWAPPABLE_AND_REPEATED_VOWELS = 3;
   SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE = 4;



    def initialize()
        @filterLevel = NONE
    end

    attr_accessor :filterLevel

    def filterInit(dictionaryFile, badwordslist)
        @goodWords = loadDictionary(dictionaryFile)
        #The original java class requiere other three word's list
        @datingWordsRegex = /dating/
        @deviantWordsRegex = /deviant/
        @badWordsRegex = loadBadwords(badwordslist)
        
        vowels = /([aeiou])/
        @vowelSwappedAndRepeatedRegex = Regexp.new(@badWordsRegex.source.gsub(vowels, "[aeiou]+"))
        @vowelSwappedAndRepeatedRegexIncludingEmpty = Regexp.new(@badWordsRegex.source.gsub(vowels, "[aeiou]*"))
	    @vowelRepeatedRegex = Regexp.new(@badWordsRegex.source.gsub(vowels, "\\1+"))
	    @vowelSwappedRegex = Regexp.new(@badWordsRegex.source.gsub(vowels, "[aeiou]"))
        
    end


    def loadDictionary(path)
        words = []
        File.open(path, "r").each_line do |line|
            splitted = line.split(" ")
            splitted.each do |w|
                words << w
            end
        end
        return words
    end

    def loadBadwords(path)
      words = File.read(path).gsub("\r", '').split("\n")
      regex = words.join('|')
      regex = '(' + regex + ')'
      regex = Regexp.new(regex)
      return regex
    end
 
    def filterString(input)

#        Output:
#		-1: An exception occured while trying to check the string, do not post
#		0: string is safe to post
#		1: string contains an email address
#		2: string contains a URL
#		3: string contains a street address
#		4: string contains a phone number
#		5: string contains a dating word
#		6: string contains a deviant word
#		9: string contains any other bad word

        input = input.strip.downcase
        workingCopy = input
        
        if input == ""
            return 0
        end
        
        if @@emailRegex.match(input)
            return 1
        end
        
        if @@urlRegex.match(input)
            return 2
        end
        
        if @@streetNameRegex.match(input)
            return 3
        end
        
        if @@phoneNumber.match(input)
            return 4
        end
        
        workingCopy.gsub("\s+", " ")
        workingCopy.gsub!(/["',.;:?-]/, " ")
        workingCopy.gsub!(/!+\s/, " ")
        workingCopy.gsub!(/!+\z/, " ")
        workingCopy.gsub!(/\br\su/, " ")
        
        cleanVersion = stripGoodWords(workingCopy)
        
        if cleanVersion == nil or cleanVersion.length == 0
            return 0
        end
        
        if @datingWordsRegex.match(cleanVersion)
            return 5
        end
        
        if @deviantWordsRegex.match(cleanVersion)
            return 6
        end
       
        if @badWordsRegex.match(cleanVersion)
            return 7
        end

        #let's try various combinations of bad word tricks
        currentVersion = cleanVersion
        
        #compress the string then check it again
        if @badWordsRegex.match(currentVersion.gsub("[ \t\n\f\r]", ""))
            return 9
        end
        
        #zap special characters and check it again
        if @badWordsRegex.match(currentVersion.gsub("[^a-z]", ""))
            return 9
        end
        
        #replace certain special characters with their letter equivalents
        #NOTE: This one maps vertical non-letter chars (!1|) to i
        specialCharsReplaced_i = currentVersion.tr("@683!1|0$+","abbeiiiost")
        if @badWordsRegex.match(specialCharsReplaced_i)
            return 9
        end
        
        #replace certain special characters with their letter equivalents
        #NOTE: This one maps vertical non-letter chars (!1|) to l
        specialCharsReplaced_l = currentVersion.tr("@683!1|0$+","abbelllost")
        if @badWordsRegex.match(specialCharsReplaced_l)
            return 9
        end
        
        case @filterLevel
        when NONE
            return 0
        when REPEATED_VOWELS
            if @vowelRepeatedRegex.match(specialCharsReplaced_i) or @vowelRepeatedRegex.match(specialCharsReplaced_l)
                return 9
            end
        when SWAPPABLE_VOWELS
            if @vowelSwappedRegex.match(specialCharsReplaced_i) or @vowelSwappedRegex.match(specialCharsReplaced_l)
                return 9
            end
        when SWAPPABLE_AND_REPEATED_VOWELS
            if @vowelSwappedAndRepeatedRegex.match(specialCharsReplaced_i) or @vowelSwappedAndRepeatedRegex.match(specialCharsReplaced_l)
                return 9
            end
        when SWAPPABLE_AND_REPEATED_VOWELS_INCLUDING_NONE
            if @vowelSwappedAndRepeatedRegexIncludingEmpty.match(specialCharsReplaced_i) or @vowelSwappedAndRepeatedRegexIncludingEmpty.match(specialCharsReplaced_l)
                return 9
            end
        end

    end

    def stripGoodWords(input)
        result = []
        input = input.split(" ")
        input.each do |w|
            if not @goodWords.include? w
                result << w
            end
        end
        return result.join(" ")
    end
  end
end
