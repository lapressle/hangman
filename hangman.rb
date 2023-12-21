# frozen_string_literal: true

require 'csv'
require 'yaml'
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
  attr_accessor :status, :guesses
  attr_reader :player, :word

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
    self.guesses += 1 unless word.include?(guess)
    status
  end

  def win?
    return 'You won!' if status == word

    false
  end

  def play_game
    while guesses < 6
      p compare_guess
      win?
      p "#{6 - guesses} guesses left!"
    end
    p "The word was #{word}"
    p 'Better luck next time!'
  end

  def save_game
    yaml = YAML.dump(self)
    File.open('database.yml', 'a') do |file|
      file.puts yaml
      file.puts ''
    end
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
    input = gets.chomp.downcase
    until input.is_a?(String) && !guesses.include?(input) && input.length == 1
      p 'try again'
      input = gets.chomp.downcase
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
p game.status
# game.play_game
game.save_game

# p YAML.load_file('database.yml', permitted_classes: [Game, Player, Word])
yaml = YAML.load_stream(File.open('database.yml'))
yaml[0].play_game
