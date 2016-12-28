require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }

set :database, { adapter: 'sqlite3', database: 'foo.sqlite3' }

class Application < Sinatra::Base
  include Helpers
  register Sinatra::ActiveRecordExtension
  use Rack::Session::Cookie
  register Sinatra::Flash

  before '/' do
    authorize
  end

  get '/' do
    @phrases = Phrase.all
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
    begin
      @phrase = Phrase.create!(params[:phrase])
      @phrase.histories.create!(user_id: User.find_by(username: session[:username]).id,
                                                      part_phrase: @phrase.name)
      { id: @phrase.id, phrase: @phrase.name }.to_json
    rescue
      { message: 'Error!' }.to_json
    end
  end

  before '/edit_phrase/:id' do
    authorize
  end

  get '/edit_phrase/:id' do
    @phrase = Phrase.eager_load(:histories).find(params[:id])
    erb :edit_phrase, layout: :application, local: @phrase
  end

  post '/update_phrase' do
    begin
      @user = User.find_by(username: session[:username])
      @phrase = Phrase.find(params[:phrase][:id])
      CheckWord.new.call(params[:phrase][:name])
      CheckOneTime.new.call(@phrase.histories.last.user.id, @user.id)
      @phrase.update!(name: "#{@phrase.name} #{params[:phrase][:name]}")
      @phrase.histories.create!(user_id: @user.id, part_phrase: @phrase.name)
      { id: @phrase.id, phrase: @phrase.name, status: 200 }.to_json
    rescue
      { message: 'The word wasn\'t added!', status: 404 }.to_json
    end
  end

  before '/sign_up' do
    not_authorize
  end

  get '/sign_up' do
    erb :registration, layout: :application
  end

  post '/create_user' do
    begin
      User.create!(params[:user])
      session[:username] = params[:user][:username]
      flash[:info] = 'You successfull create self account!'
      redirect '/'
    rescue
      flash[:warning] = 'Wrong data!'
      redirect '/'
    end
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
      flash[:info] = 'You successfull authorize!'
      redirect '/'
    else
      flash[:warning] = 'Your username or password incorrect!'
      redirect '/sign_in'
    end
  end

  post '/logout' do
    session.clear
    redirect '/sign_in'
  end
end
