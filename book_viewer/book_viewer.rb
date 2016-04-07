require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require 'pry'

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @chapters = File.readlines("data/toc.txt")
  @chapter_num = 0
  @title = @chapters[@chapter_num]
  @chapter_content = File.read("data/chp1.txt")
  erb :chapter
end
