require 'sinatra/base'
require './app/data_mapper_setup'

class Bookmark_manager < Sinatra::Base
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
    link = Link.create(url: params[:url], title: params[:title])
    tag_list = params[:tag].split(" ")
    tag_list.each do |each_tag|
      tag = Tag.create(name: each_tag)
      link.tags << tag
    end
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  run! if app_file == Bookmark_manager
end
