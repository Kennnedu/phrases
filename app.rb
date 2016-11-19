class App < Sinatra::Base
  get '/' do
    erb :index, layout: :application #, locals: { arr: }
  end
  get '/sin_in' do
    erb :login, layout: :application
  end

  get '/sign_up' do
    erb :registration, layout: :application
  end

  get '/new_phrase' do
    erb :new, layout: :application
  end

  get '/edit_phrase/:id' do
    erb :edit, layout: :application
  end

  post '/create_phrase/:name' do

  end
end
