module ApplicationHelper
  # Small ✓ / · marker for boolean columns in the aid-station tables.
  def yes_no(flag)
    if flag
      tag.span "✓", class: "font-bold text-pine", title: "Yes"
    else
      tag.span "·", class: "text-stone-light", title: "No"
    end
  end
end
