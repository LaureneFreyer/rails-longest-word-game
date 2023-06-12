class GamesController < ApplicationController

  def user
    @user = params[:user]
  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def score
    attempt = params[:word]
    letters = params[:letters]
    if included?(attempt.upcase, letters)
      if english_word?(attempt)
        @score = "Congratulations! #{attempt.upcase} is a valid English word! Your score is #{attempt.size}"
      else
        @score = "Sorry but #{attempt.upcase} does not seem to be a valid English word..."
      end
    else
      @score = "Sorry but #{attempt.upcase} can't be built out of #{letters}"
    end
  end
end
