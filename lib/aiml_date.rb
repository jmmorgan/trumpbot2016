class AimlDate
  include TemplateContentNode

  def apply(path_mathcher_result, graphmaster, predicates)
    Date.today.strftime(format)
  end

  def format
    self.attributes['format'] || '%B %d, %Y'
  end

end
