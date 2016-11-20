require 'sinatra'
require 'sinatra/activerecord'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }

set :database, { adapter: 'sqlite3', database: 'foo.sqlite3' }

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  use Rack::Session::Cookie

  before '/' do
    authorize
  end

  get '/' do
    @phrases = Phrase.all
    @users = User.all
    @session = session[:username]
    erb :index, layout: :application
  end

  before '/new_phrase' do
    authorize
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

  before '/edit_phrase/:id' do
    authorize
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

  before '/sign_up' do
    not_authorize
  end

  get '/sign_up' do
    erb :registration, layout: :application
  end

  post '/create_user' do
    User.create!(params[:user])
    session[:username] = params[:user][:username]
    redirect '/'
    raise
    redirect '/'
    'kasjhdgfkajsvdf'
  end

  before '/sign_in' do
    not_authorize
  end

  get '/sign_in' do
    erb :login, layout: :application
  end

  post '/loggin' do
    @user = User.where(username: params[:user][:username])
    if @user.first.present? && @user.first.password == params[:user][:password]
      session[:username] = @user.first.username
      redirect '/'
    else
      redirect '/sign_in'
    end
  end

  post '/logout' do
    session.clear
    redirect '/sign_in'
  end

  private 

  def authorize
    redirect '/sign_in' if session[:username].nil?
  end

  def not_authorize
    redirect '/' if session[:username]
  end
end
