require 'yaml'


class Hangman 
  attr_accessor :word, :guess_word, :guessed_letters, :turn_passed, :load_option
  def initialize
    load?

    if @load_option == 'y'
      @word = load_game.word
      @guess_word = load_game.guess_word
      @guessed_letters = load_game.guessed_letters
      @turn_passed = load_game.turn_passed
    else
    @word = random_word
    @guess_word = ''
    @word.length.times {@guess_word += '-'}
    @guessed_letters = []
    @turn_passed = 0
    end
  end

  # game start, load dictionary and select a word between 5-12 characters
  def random_word
    dictionary = File.read('5desk.txt').split(/\r\n/)
    word_length = rand(5..12)
    possible_words = dictionary.select { |word| word.length == word_length }
    possible_words[rand(0..possible_words.length)].downcase
  end

  def save_game(state)
    yaml = YAML::dump state 
    game_file = File.open('./saved.yaml', 'w')
    game_file.write yaml 
    game_file.close
  end

  def load_game
    game_file = File.open('./saved.yaml')
    yaml = game_file.read
    YAML::load yaml
  end

  def save?
    print 'save?(y/n) '
    save_option = gets.chomp
    if save_option == 'y'
      self.save_game(self)
    end
  end

def load?
    print 'load saved game?(y/n) '
    @load_option = gets.chomp
   if @load_option == 'y'
     self.load_game
   end
end

  def a_guess 
    #ask user for guess 
    print 'what is you guess? '
    guess = gets.chomp
  end

  def check_guess(the_guess)

    #check if word has guess and replaces graphical representation with answer(s)
    i = 0
    while i < @word.length
      if @word[i] == the_guess
        @guess_word[i] = the_guess
      end
      i += 1
    end
    @guessed_letters.push the_guess unless @guess_word.include?(the_guess)
  end

  #prints initial graphical representation of guesses
  #turn end, so should display used letters as well as
  #guessed answers and turns left
  def start
    for j in @turn_passed..9 do
      @turn_passed = j
      save?
      check_guess(a_guess)
      puts "guesses left #{9-j}"
      puts @guess_word
      puts @guessed_letters.join('-')
      unless @guess_word.include?('-')
        puts 'you win'
        break
      end
    end
    if @guess_word.include?('-')
      puts 'you lose'
    end
  end
end


