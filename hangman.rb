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
    return p 'You won!' if status == word

    false
  end

  def play_game
    while guesses < 6
      p compare_guess
      return if win?

      p "#{6 - guesses} guesses left!"
      p 'Would you like to save (y/n)?'
      return save_game if gets.chomp == 'y'
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

def on_loading(word_options)
  p 'Would you like to load a previous game? (y/n)'
  if gets.chomp == 'y'
    load_game
  else
    game_start(word_options)
  end
end

def load_game
  yaml = YAML.load_stream(File.open('database.yml'))
  input = pick_file(yaml) - 1
  p yaml[input].status
  yaml[input].play_game
end

def pick_file(options)
  p "Pick a file # from 1 to #{options.length}"
  file_number = gets.chomp.to_i
  until file_number.is_a?(Integer) && file_number.between?(1, options.length)
    p 'Try another #'
    file_number = gets.chomp.to_i
  end
  file_number
end

def game_start(word_options)
  word = pick_word(word_options).word
  player = Player.new
  game = Game.new(player, word)
  p game.status
  game.play_game
end

on_loading(word_options)
