require 'net/http'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def correct_letters?(input, letters)
    input.each do |letter|
      return false unless letters.include?(letter)

      letters.delete(letter)
    end
  end

  def english?(input)
    url = URI.parse("https://api.dictionaryapi.dev/api/v2/entries/en/#{input}")
    response = Net::HTTP.get_response(url)
    data = JSON.parse(response)
    puts data
  end

  def score
    input = params[:answer].upcase
    input_chars = input.chars
    if correct_letters?(input_chars, params[:letters]) && english?(input)
      @results = "Congratulations! #{input} is a valid English word!"
    else
      if correct_letters?(input_chars, params[:letters])
        @results = "Sorry but #{input} does not seem to be an English word..."
      else
       @results = "Sorry but #{input} can't be built out of #{params[:letters]}"
      end
    end
    render(:score)
  end
end
