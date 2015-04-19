require "json"
require "nokogiri"
require "open-uri"
require "uri"


class HackerNews

  ENDPOINT    = "https://news.ycombinator.com/"
  MAX_ENTRIES = 25

  def fetch(&block)
    entries = []

    load_rows.each_with_index do |row, index|
      # Primary row
      if index.even?
        entries << {
          :title                      => title(row),
          :url                        => url(row),
          :host                       => host(row)
        }

      # Secondary row
      elsif !entries.empty?
        entries.last[:votes_count]    = votes_count(row)
        entries.last[:comments_count] = comments_count(row)
        entries.last[:href]           = href(row)
        entries.last[:created]        = created(row)
        entries.last[:user_name]      = user_name(row)
        entries.last[:user_href]      = user_href(row)
      end
    end

    entries = entries[0...MAX_ENTRIES]

    yield(entries) if block_given?
    entries
  end

private

  def load_rows
    page = Nokogiri::HTML(open(ENDPOINT))
    rows = page.css('table#hnmain table')[1].css('tr:not(.spacer):not(.morespace)')

    rows.pop
    rows
  end

  def title(row)
    row.css('td.title a').text
  end

  def url(row)
    row.css('td.title a').attr('href').value
  end

  def host(row)
    matches = row.css('td.title span.sitebit').text.match(/\((.*)\)/)
    return matches[1] unless matches.nil?

    uri = URI.parse(ENDPOINT)
    "#{uri.scheme}://#{uri.host}"
  end

  def votes_count(row)
    sub_text(row).css('span.score').text.to_i
  end

  def comments_count(row)
    sub_text(row).css('a').last.text.to_i
  end

  def href(row)
    ENDPOINT + sub_text(row).css('a').last.attr('href')
  end

  def created(row)
    sub_text(row).css('a')[1].text
  end

  def user_name(row)
    sub_text(row).css('a').first.text
  end

  def user_href(row)
    ENDPOINT + sub_text(row).css('a').first.attr('href')
  end

  def sub_text(row)
    row.css('td.subtext')
  end
end