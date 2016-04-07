require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"
require 'pry'

before do
  @users = YAML.load_file("public/users.yaml")
  @interest_count = @users.inject(0) { |sum, user| sum + user[1][:interests].size }
end

get "/" do
  redirect "/users"
end

get "/users" do
  @title = "User List"
  erb :users
end

get "/users/:name" do
  @title = params[:name].to_s.capitalize
  @user = @users[params[:name].to_sym]
  erb :show_user
end