require 'sinatra'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/flash'
require 'json'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each { |file| require file }

include Helpers

enable :sessions
set :session_secret, '1234567'
set :database, { adapter: 'postgresql',
  encoding: 'unicode', database: 'your_database_name', pool: 2,
  username: 'roman', password: 'password' }
set :server, 'thin'
set :sockets, []
register Sinatra::ActiveRecordExtension
register Sinatra::Flash

after do
  ActiveRecord::Base.clear_active_connections!
end

get '/' do
  authorize
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
        elsif msg['method'] == 'show-history'
          response = show_history(msg['id'])
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

get '/sign_up' do
  not_authorize
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

get '/sign_in' do
  not_authorize
  erb :login, layout: :application
end

post '/login' do
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

# ActiveRecord::ConnectionTimeoutError
