require 'sinatra'
require 'sinatra/activerecord'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }

set :database, { adapter: 'sqlite3', database: 'foo.sqlite3' }

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    @phrases = Phrase.all
    @users = User.all
    erb :index, layout: :application, local: @phrases
  end

  get '/new_phrase' do
    erb :new_phrase, layout: :application
  end

  post '/create_phrase' do
    Phrase.create!(params[:phrase])
    redirect "/"
    raise
    redirect "/"
    'Validate error'
  end

  get '/edit_phrase/:id' do
    @phrase = Phrase.find(params[:id])
    erb :edit_phrase, layout: :application, local: @phrase
  end

  post '/update_phrase' do
    @phrase = Phrase.find(params[:phrase][:id])
    @phrase.update!(name: "#{@phrase.name} #{params[:phrase][:name]}")
    redirect '/'
    raise
    redirect '/'
    'alaksjghdfk'
  end

  get '/sign_up' do
    erb :registration, layout: :application
  end

  post '/create_user' do
    @user = User.create!(params[:user])
    redirect '/'
    raise
    redirect '/'
    'kasjhdgfkajsvdf'
  end

  get '/sign_in' do
    erb :login, layout: :application
  end
end
