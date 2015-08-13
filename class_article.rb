require 'uri'

class Article

  attr_accessor :title, :url, :description, :errors

  def initialize(info_hash={})
    @title = info_hash["article_title"]
    @url = info_hash["article_url"]
    @description = info_hash["article_description"]
    @errors = []
  end

  def self.all
    articles = []
    raw_csv = File.readlines('articles.csv')
    raw_csv.each do |line|
      articles << Article.new(line_to_hash(line))
    end
    articles
  end

  def self.line_to_hash(line)
    info = {}
    line_split = line.split(',')
    info["article_title"] = line_split[0].strip
    info["article_url"] = line_split[1].strip
    info["article_description"] = line_split[2].strip
    info
  end



  def title_valid?
    valid = title.length > 0
    errors << "Invalid title!" unless valid
    valid
  end

  def url_valid?
    valid = url =~ /[.]/
    errors << "Invalid URL!" unless valid
    valid
  end

  def description_valid?
    valid = description.length >= 20
    errors << "Invalid description" unless valid
    valid
  end

  def new_url?
    valid = !Article.all.any? {|article| article.url == url}
    errors << "Need a new URL" unless valid
    valid
  end

  def valid?
    valid1 = title_valid?
    valid2 = description_valid?
    valid3 = url_valid?
    valid4 = new_url?
    valid1 && valid2 && valid3 && valid4
  end

  def to_csv
    "#{title},#{url},#{description}"
  end

  def save
    valid = valid?
    if valid
      File.open('articles.csv', 'a') do |file|
        file.puts(to_csv)
      end
    end
    valid
  end
end
