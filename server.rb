require 'sinatra'
require 'shotgun'
require 'pry'

get '/articles' do
  @article_info_lines = File.readlines('articles.csv')
  erb :index
end

get '/articles/new' do
  @article_info_lines = ["test"]
  erb :article_submit
end

post '/articles/new/submit' do

  article_string = concatenate_article(params)

  File.open('articles.csv', 'a') do |file|
    file.puts(article_string)
  end

  redirect '/articles'
end

helpers do

  def parse_line(line)
    info = {}
    line_split = line.split(',')
    info["article_title"] = line_split[0].strip
    info["article_url"] = line_split[1].strip
    info["article_description"] = line_split[2].strip
    info
  end

end


def concatenate_article (params)
  article_info = []
  params.each do |key, value|
    article_info << value
  end
  article_string = article_info.join(',')
end
