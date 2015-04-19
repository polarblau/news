module HtmlHelpers

  # set and retrieve a document title
  # Usage:
  #   title("foo"); title(["bar", "bat"])
  #   title # => "foo | bar | bat"
  def title(fragment = nil, separator = " | ")
    @title ||= [current_page.data.title]
    @title << fragment
    @title.flatten.compact.reject(&:empty?).join(separator)
  end

  # Render HTML tag with conditional tags for IE
  def ie_html(attrs={}, &block)
    attrs.keys.each do |key|
      attrs[(key.to_sym rescue key) || key] = attrs.delete(key)
    end
    haml_concat("<!--[if lt IE 7]>#{ tag(:html, add_class('ie6', attrs), true) }<![endif]-->")
    haml_concat("<!--[if IE 7]>#{ tag(:html, add_class('ie7', attrs), true) }<![endif]-->")
    haml_concat("<!--[if IE 8]>#{ tag(:html, add_class('ie8', attrs), true) }<![endif]-->")
    haml_concat("<!--[if gt IE 8]><!-->")
    haml_tag :html, attrs do
      haml_concat("<!--<![endif]-->")
      block.call
    end
  end

  def simple_url(url)
    uri = URI.parse(url)
    uri.hostname + uri.path
  end

private

  def add_class(name, attrs)
    classes = attrs[:class] || ''
    classes.strip!
    classes = ' ' + classes if !classes.empty?
    classes = name + classes
    attrs.merge(:class => classes)
  end

end

