#!/usr/bin/env ruby
require 'logger'
require 'clockwork'

require_relative './hacker_news'
require_relative './designer_news'

module Clockwork

  DESIGNER_NEWS_FILE = File.expand_path("../../data/designer_news.json", __FILE__)
  HACKER_NEWS_FILE   = File.expand_path("../../data/hacker_news.json", __FILE__)
  LOG_FILE           = File.expand_path("../../../shared/clock.log", __FILE__)

  logger = Logger.new(LOG_FILE, 10, 1024000)

  every(1.minute, 'fetch.all.news') do
    logger.info('designer_news') { "Fetching news from Designer News..." }
    DesignerNews.new.fetch do |entries|
      File.open(DESIGNER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
    end
    logger.info('hacker_news') { "Done." }

    puts "Fetching news from Hacker News..."
    logger.info('hacker_news') { "Fetching news from Hacker News..." }
    HackerNews.new.fetch do |entries|
      File.open(HACKER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
    end
    logger.info('hacker_news') { "Done." }

    logger.info('middleman') { "Rebuilding views..." }
    `bundle exec middleman build`
    logger.info('middleman') { "Done." }
  end
end