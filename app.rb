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
  @username = session[:username]
  erb :index, layout: :application
end

get '/phrases' do
  authorize
  @phrases = Phrase.recent_updated
  json user: { id: session[:user_id], username: session[:username] },
    phrases: @phrases.as_json(only: [:id, :current_state, :updated_at])
end

post '/phrase' do
  authorize
  @phrase = Phrase.new(current_state: params[:beginning_phrase])
  if @phrase.save
    json phrase: @phrase.as_json(only: [:id, :current_state, :updated_at])
  else
    status 404
    json message: @phrase.errors.full_messages.join(' ')
  end
end

post '/word' do
  authorize
  @word = Word.new(user_id: session[:user_id], phrase_id: params[:phrase_id].to_i,
    word: params[:word])
  if @word.save
    json phrase: @word.phrase.as_json(only: [:id, :current_state, :updated_at])
  else
    status 404
    json message: @word.errors.full_messages.join(' ')
  end
end

get '/history/:phrase_id' do
  authorize
  @words = Phrase.find(params[:phrase_id]).words.includes(:user)
    .as_json(only: [:id, :word, :previous_phrase, :created_at], include: { user: { only: :username }})
  json words: @words
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
