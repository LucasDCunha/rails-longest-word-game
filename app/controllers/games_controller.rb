require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @start_time = Time.now.to_i
    generate_letters
    @letters
  end

  def score
    get_score(params[:answer], params[:start_time], params[:letters])
    @score
  end

  def generate_letters
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def validate_answer(answer, letters)
    validator = true
    answer.chars.each do |char|
      validator = false if answer.count(char) != letters.count(char)
    end
    validator
  end

  def get_score(answer, start_time, letters)
    @score = 0
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    api = JSON.parse(open(url).read)
    if api['found'] && validate_answer(answer, letters)
      @score = (answer.size * 100) / (Time.now.to_i - start_time.to_i)
    end
    @score = 'Not a word' unless api['found']
  end
end
