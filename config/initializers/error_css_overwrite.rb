ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|textarea|select)/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.alternative_style("error")
    html_field.to_html.html_safe
  else
    html_tag
  end
end
