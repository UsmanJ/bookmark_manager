require 'sinatra/base'
require './data_mapper_setup'

class Bookmark_manager < Sinatra::Base

  get '/' do
    erb :'links/home'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new_links' do
    erb :'links/new_links'
  end

  post '/links' do
    Link.create(url: params[:url], title: params[:title])
    redirect to('/links')
  end

# start the server if ruby file executed directly
run! if app_file == Bookmark_manager
end