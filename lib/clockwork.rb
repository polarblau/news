#!/usr/bin/env ruby

require 'clockwork'

require_relative './hacker_news'
require_relative './designer_news'


module Clockwork

  DESIGNER_NEWS_FILE = File.expand_path("../../data/designer_news.json", __FILE__)
  HACKER_NEWS_FILE   = File.expand_path("../../data/hacker_news.json", __FILE__)

  every(1.minute, 'fetch.all.news') do
    DesignerNews.new.fetch do |entries|
      File.open(DESIGNER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
    end

    HackerNews.new.fetch do |entries|
      File.open(HACKER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
    end
  end
end