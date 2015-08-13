require 'sinatra'
require 'shotgun'
require 'pry'
require_relative 'class_article'

get '/articles' do
  @articles = Article.all
  erb :index
end

get '/articles/new' do
  @article = Article.new
  erb :article_submit
end

post '/articles/new/submit' do
  @article = Article.new(params)
  if @article.save
    redirect '/articles'
  else
    erb :article_submit
  end
end
