class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :displayed
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @displayed = ''
  end
  
  def length
    return @word.length
  end
  
  def guess(s)
    if (/\A[a-zA-Z]\Z/ =~ s) == 0 then 
      s = s.downcase
      if @wrong_guesses.include? s or @guesses.include? s then
        return false
      elsif @word.include? s then
        @guesses += s
        word_with_guesses
        return true
      else
        @wrong_guesses += s
        return true
      end
      return false
    else
      raise ArgumentError
    end
  end
    
  def guess_several_letters(letters)
    new_list = letters.split(//)
    new_list.each do |x|
      guess(x)
    end
  end
  
  def word_with_guesses
    new_word = ""
    word_asList = @word.split(//)
    word_asList.each { |letter|
      if @guesses.include? letter then
        new_word += letter
      else
        new_word += "-"
      end
    }
    @displayed = new_word
    return new_word
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7 and word_with_guesses != @word then
      return :lose
    elsif @word == word_with_guesses and @wrong_guesses.length <= 7 then 
      return :win
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
