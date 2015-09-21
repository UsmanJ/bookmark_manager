require 'rubygems'
require File.join(File.dirname(__FILE__), './app/app.rb')

require 'data_mapper'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

run Bookmark_manager
