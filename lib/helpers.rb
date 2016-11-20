module Helpers
  def authorize
    redirect '/sign_in' if session[:username].nil?
  end

  def not_authorize
    redirect '/' if session[:username]
  end
end
