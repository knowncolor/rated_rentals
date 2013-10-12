module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def wrap_long_string(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
        text.scan(regex).join(zero_width_space)
  end

end
