require 'sinatra'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'json'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |file| require file }

include Helpers

enable :sessions
set :session_secret, '1234567'
set :database, { adapter: 'postgresql',
  encoding: 'unicode', database: 'your_database_name', pool: 2,
  username: 'roman', password: 'password'}
set :server, 'thin'
set :sockets, []
register Sinatra::ActiveRecordExtension

after do
  ActiveRecord::Base.clear_active_connections!
end 

before '/' do
  authorize
end

get '/' do
  if !request.websocket?
    @phrases = Phrase.all
    @session = session[:username]
    erb :index, layout: :application
  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("Hello World!")
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        msg = JSON.parse(msg)
        if msg['method'] == 'create'
          response = create_phrase(msg['phrase'], session[:username])
          EM.next_tick { settings.sockets.each{|s| s.send(response) } }
        elsif msg['method'] == 'update'
          response = update_phrase(msg, session[:username])
          EM.next_tick { settings.sockets.each{|s| s.send(response) } }
        end
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

before '/new_phrase' do
  authorize
end

get '/new_phrase' do
  erb :new_phrase, layout: :application
end

before '/edit_phrase/:id' do
  authorize
end

get '/edit_phrase/:id' do
  @phrase = Phrase.eager_load(:histories).find(params[:id])
  erb :edit_phrase, layout: :application, local: @phrase
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
    # flash[:info] = 'You successfull create self account!'
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

post '/login' do
  @user = User.where(username: params[:user][:username])
  if @user.first.present? && @user.first.password == params[:user][:password]
    session[:username] = @user.first.username
    # flash[:info] = 'You successfull authorize!'
    redirect '/'
  else
    # flash[:warning] = 'Your username or password incorrect!'
    redirect '/sign_in'
  end
end

post '/logout' do
  session.clear
  redirect '/sign_in'
end

# ActiveRecord::ConnectionTimeoutError