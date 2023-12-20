# frozen_string_literal: true

require 'csv'
dictionary = CSV.open('google-10000-english-no-swears.txt')

word_options = []
dictionary.each do |word|
  word_options.push(word[0]) if word[0].length >= 5 && word[0].length <= 12
end

# defines hangman word
class Word
  attr_reader :word

  def initialize(word)
    @word = word
  end
end

# Rules of the game and running it
class Game
  attr_accessor :status
  attr_reader :player, :word
  attr_writer :guesses

  def initialize(player, word)
    @player = player
    @word = word
    @guesses = 0
    @status = ''
    word.split('').length.times { @status += '_' }
  end

  def compare_guess
    guess = player.guess
    word.each_char.with_index do |letter, index|
      status[index] = guess if letter == guess
    end
    status
  end
end

# defines Player ability to guess
class Player
  attr_accessor :guesses

  def initialize
    @guesses = []
  end

  def guess
    p 'Pick a letter'
    input = gets.chomp
    until input.is_a?(String) && !guesses.include?(input)
      p 'try again'
      input = gets.chomp
    end
    guesses << input
    input
  end
end

def pick_word(list)
  Word.new(list[rand(0..list.length)])
end

word = pick_word(word_options).word
player = Player.new
game = Game.new(player, word)
p game.compare_guess
p game.compare_guess
