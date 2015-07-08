require 'sinatra'
require 'csv'
require 'json'

get '/' do
   erb :index
end

post '/result' do
  # Read the input csv file and create a hash with word = key and count = value
  words_count = Hash.new
  CSV.foreach(params['inputFile'][:tempfile]) do |row|
    row.each do |word|
      if !words_count.has_key?(word.downcase!)
        words_count[word] = 1
      else
        words_count[word] += 1
      end
    end
  end

  # jQCloud library expects words to be in format of
  # {text: 'word', wight: 'size'} so converting to array of these formats
  words = Array.new
  words_count.each do |key, value|
    words << {:text => key,
              :weight => value}
  end

  # Render result.erb template and pass local variable words as keywords
  erb :result, :locals => {:keywords => words.to_json}
end
