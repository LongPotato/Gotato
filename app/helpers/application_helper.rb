module ApplicationHelper

  #Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Gotato"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  #Check if string is a number
  def is_number? string
    true if Float(string) rescue false
  end

end





