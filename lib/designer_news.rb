require "httparty"
require "json"
require "uri"
require "time"
require "action_view"


class DesignerNews
  include ActionView::Helpers::DateHelper

  ENDPOINT    = 'https://api-news.layervault.com/api/v2/stories?include=user' # ?page=2
  HOST        = 'https://news.layervault.com'
  MAX_ENTRIES = 25

  def fetch
     rows    = load_rows

     stories = rows['stories']
     users   = rows['linked']['users']

     entries = stories.map do |row|
      user = find_user(user_id(row), users)

      {
        :title          => title(row),
        :url            => url(row),
        :href           => href(row),
        :votes_count    => votes_count(row),
        :comments_count => comments_count(row),
        :host           => host(row),
        :created        => created(row),
        :user_name      => user_name(user),
        :user_href      => user_href(user)
      }
    end

    entries = entries[0...MAX_ENTRIES]

    yield(entries) if block_given?
    entries
  end

private

  def find_user(id, users)
    users.find { |u| u['id'] == id }
  end

  def load_rows
    response = HTTParty.get(ENDPOINT)
    JSON.parse(response.body)
  end

  def title(row)
    row['title']
  end

  def url(row)
    row['url'].empty? ? href(row) : row['url']
  end

  def href(row)
    row['href']
  end

  def votes_count(row)
    row['vote_count']
  end

  def comments_count(row)
    row['comment_count']
  end

  def created(row)
    "#{time_ago_in_words(Time.parse(row['created_at']))} ago"
  end

  def user_id(row)
    row['links']['user']
  end

  def user_name(user)
    user['display_name']
  end

  def user_href(user)
    "#{HOST}/u/#{user['id']}"
  end

  def host(row)
    row['hostname'] || HOST
  end

end