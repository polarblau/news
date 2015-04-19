require_relative './hacker_news'
require_relative './designer_news'

DESIGNER_NEWS_FILE = File.expand_path("../../data/designer_news.json", __FILE__)
HACKER_NEWS_FILE   = File.expand_path("../../data/hacker_news.json", __FILE__)

desc "Update news data files"
task :fetch_news do
  puts "Fetching news from Designer News..."
  DesignerNews.new.fetch do |entries|
    File.open(DESIGNER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
  end
  puts "Done."

  puts "Fetching news from Hacker News..."
  HackerNews.new.fetch do |entries|
    File.open(HACKER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
  end
  puts "Done."

  puts "Rebuilding views..."
  `bundle exec middleman build`
  puts "Done."
end