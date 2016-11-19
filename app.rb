require 'sinatra'
require 'sinatra/activerecord'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    @phrases = Phrase.all
    erb :index, layout: :application, local: @phrases
  end
  
  get '/sign_in' do
    erb :login, layout: :application
  end

  get '/sign_up' do
    erb :registration, layout: :application
  end

  get '/new_phrase' do
    erb :new_phrase, layout: :application
  end

  get '/edit_phrase/:id' do
    erb :edit, layout: :application
  end

  post '/create_phrase/:name' do
  end
end
