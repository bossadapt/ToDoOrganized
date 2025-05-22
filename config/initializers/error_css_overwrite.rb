ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|textarea|select)/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.each do |child|
      child["class"] = [ child["class"], "error" ].compact.join(" ")
    end
    html_field.to_html.html_safe
  else
    html_tag
  end
end
