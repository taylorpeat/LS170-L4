require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?

before do
  @chapters = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index { |paragraph, idx| "<p id='#{idx}'>#{paragraph}</p>"}.join('')
  end

  def search_chapters(search)
    @paragraphs = {}
    @chapters.each_with_index do |chapter, idx|
      File.read("data/chp#{idx + 1}.txt").split("\n\n").each_with_index do |paragraph, p_idx|
        if search && paragraph.downcase.match(search.downcase)
          @paragraphs[chapter] = [paragraph, p_idx]
          break
        end
      end
    end
    highlight_search_terms(search)
  end

  def highlight_search_terms(search)
    @paragraphs.values.map! do |paragraph|
      idx = paragraph[0] =~ /#{search}/
      paragraph[0].insert(idx + search.length, "</strong>")
      paragraph[0].insert(idx, "<strong>")
    end
  end
end


get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @chapter_num = params[:number].to_i - 1
  @title = @chapters[@chapter_num]
  @chapter_content = in_paragraphs(File.read("data/chp#{params[:number]}.txt"))
  erb :chapter
end

get "/search" do
  search_chapters(params[:query])
  erb :search
end

not_found do
  redirect "/"
end


