require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].each { |file| require file }

include ApplicationHelpers

enable :sessions
set :session_secret, '1234567'
set :database, { adapter: 'postgresql',
  encoding: 'unicode', database: 'your_database_name', pool: 2,
  username: 'roman', password: 'password' }
set :server, 'thin'
set :sockets, []
register Sinatra::ActiveRecordExtension

after do
  ActiveRecord::Base.clear_active_connections!
end

get '/' do
  authorize
  @phrases = Phrase.recent_updated
  @username = session[:username]
  erb :index, layout: :application
end

post '/create_phrase' do
  authorize
  @phrase = Phrase.new(current_state: params[:beginning_phrase])
  if @phrase.save
    json id: @phrase.id, phrase: @phrase.current_state
  else
    status 404
    json message: @phrase.errors.messages
  end
end

post '/create_word' do
  authorize
  @word = Word.new(user_id: session[:user_id], phrase_id: params[:word][:phrase_id].to_i,
    word: params[:word][:word])
  if @word.save
    json id: @word.id, phrase: @word.word
  else
    status 404
    json message: @word.errors.messages
  end
end

get '/history/:phrase_id' do
  authorize
  @phrases = Phrase.eager_load(:words).find(params[:phrase_id])
  json phrases: @phrases
end

get '/sign_up' do
  not_authorize
  erb :registration, layout: :application
end

post '/create_user' do
  begin
    @user = User.create!(params[:user])
    session[:user_id], session[:username] = @user.first.id, @user.first.username
    redirect '/'
  rescue
    redirect '/'
  end
end

get '/sign_in' do
  not_authorize
  erb :login, layout: :application
end

post '/login' do
  @user = User.where(username: params[:user][:username])
  if @user.first.present? && @user.first.password == params[:user][:password]
    session[:user_id], session[:username] = @user.first.id, @user.first.username
    redirect '/'
  else
    redirect '/sign_in'
  end
end

post '/logout' do
  session.clear
  redirect '/sign_in'
end
