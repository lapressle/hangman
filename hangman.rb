# frozen_string_literal: true

require 'csv'
dictionary = CSV.open('google-10000-english-no-swears.txt')

word_options = []
dictionary.each do |word|
  word_options.push(word[0]) if word[0].length >= 5 && word[0].length <= 12
end

puts word_options
