require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }

set :database, { adapter: 'postgresql',
  encoding: 'unicode', database: 'your_database_name', pool: 2,
  username: 'roman', password: 'password'}

after do
  ActiveRecord::Base.clear_active_connections!
end

get '/' do
  haml :index
end

get '/phrases' do
  { phrases: Phrase.all }.to_json
end

post '/phrase' do
  params_json = JSON.parse(request.body.read)
  { phrase: Phrase.create(params_json['phrase']) }.to_json
end

put '/phrase/:id' do
  params_json = JSON.parse(request.body.read)
  @phrase = Phrase.find(params[:id])
  @phrase.update(name: params_json['phrase'])
  { phrase: @phrase.name }.to_json
end

delete '/phrase/:id' do
  { message: Phrase.destroy(params[:id]) }.to_json
end
