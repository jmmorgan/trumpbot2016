class AimlDate
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    Date.today.strftime(format)
  end

  def format
    self.attributes['format'] || '%B %d, %Y'
  end

end
