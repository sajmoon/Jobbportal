module Textile
  def self.to_html(markdown)
    "" if markdown.blank?
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

    redcarpet.render(markdown)
  end
end
