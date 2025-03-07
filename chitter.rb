require 'sinatra/base'
require 'sinatra/reloader'
require './lib/peep'
require './lib/user'

class Chitter < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get '/' do
    if session[:user]
      @username = session[:user].username
    end
    erb(:index)
  end

  get '/peeps/new' do
    if session[:user]
      @user_id = session[:user].id
      erb(:new_peep)
    else
      redirect to('/')
    end
  end

  post '/peeps' do
    Peep.create(content: params[:content], 
      user_id: session[:user].id)
    redirect to('/')
  end

  get '/users/new' do
    erb(:new_user)
  end

  post '/users' do
    user = User.create(username: params[:user_name], 
      email: params[:email], 
      password: params[:password])
    session[:user] = user
    redirect to('/')
  end
end
