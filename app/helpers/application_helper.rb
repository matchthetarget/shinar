module ApplicationHelper
  def smart_timestamp(datetime)
    return "" if datetime.nil?

    now = Time.current
    yesterday = 1.day.ago.to_date

    if datetime.to_date == now.to_date
      # Today: show time (4:33 PM)
      datetime.strftime("%l:%M%p").strip.downcase
    elsif datetime.to_date == yesterday
      # Yesterday
      "Yesterday"
    elsif datetime > now.beginning_of_week
      # This week: show day name (Fri, Sat)
      datetime.strftime("%a")
    elsif datetime > 1.year.ago
      # Less than a year ago: day and month (Apr 3)
      datetime.strftime("%b %-d")
    else
      # More than a year ago: day month year (Apr 3 2023)
      datetime.strftime("%b %-d %Y")
    end
  end

  def markdown_render(text)
    return "" if text.blank?

    # First sanitize the HTML to remove potentially dangerous tags
    sanitized_text = ActionController::Base.helpers.sanitize(text)

    # Then render as markdown
    Kramdown::Document.new(sanitized_text, input: "GFM", syntax_highlighter: nil).to_html.html_safe
  end
end
