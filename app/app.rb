require './app/data_mapper_setup'
require 'sinatra/partial'

class Bookmark_manager < Sinatra::Base

  use Rack::MethodOverride
  enable :sessions
  register Sinatra::Flash
  register Sinatra::Partial
  set :session_secret, 'super secret'
  set :partial_template_engine, :erb

  get '/' do
    redirect to('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new_links' do
    erb :'links/new_links'
  end

  post '/links' do
    output = ""
    output << partial(:'../controllers/post_links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  delete '/sessions' do
    flash.now[:notice] = :goodbye!
    session[:user_id] = nil
    erb :'sessions/goodbye'
  end

  post '/sessions' do
    output = ""
    output << partial(:'../controllers/post_sessions')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == Bookmark_manager
end
