#!/usr/bin/env ruby
require 'logger'
require 'clockwork'

require_relative './hacker_news'
require_relative './designer_news'

module Clockwork

  DESIGNER_NEWS_FILE = File.expand_path("../../data/designer_news.json", __FILE__)
  HACKER_NEWS_FILE   = File.expand_path("../../data/hacker_news.json", __FILE__)
  LOG_FILE           = File.expand_path("../../../../shared/log/clock.log", __FILE__)

  logger = Logger.new(LOG_FILE, 10, 1024000)

  every(1.minute, 'fetch.all.news') do
    begin
      logger.info("Fetching news from Designer News...")
      DesignerNews.new.fetch do |entries|
        File.open(DESIGNER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
      end
      logger.info("Done.")
    rescue Exception => e
      logger.error("Fetching news from Desiger News failed!\n#{e.message}")
    end

    begin
      logger.info("Fetching news from Hacker News...")
      HackerNews.new.fetch do |entries|
        File.open(HACKER_NEWS_FILE, 'w') { |f| f.write(entries.to_json) }
      end
      logger.info("Done.")
    rescue Exception => e
      logger.error("Fetching news from Hacker News failed!\n#{e.message}")
      puts e
    end

    begin
      logger.info("Rebuilding views...")
      `bundle exec middleman build`
      logger.info("Done.")
    rescue Exception => e
      logger.error("Rebuilding views failed!\n#{e.message}")
    end
  end
end