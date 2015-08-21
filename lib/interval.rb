class Interval
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    reult = nil
    from = tokens.select{|token| token.is_a?(From)}.first
    to = tokens.select{|token| token.is_a?(To)}.first
    style = tokens.select{|token| token.is_a?(Style)}.first
    if (from && to)
      formatted_from = from.apply(star_mappings, graphmaster, predicates, category_stack)
      formatted_to = to.apply(star_mappings, graphmaster, predicates, category_stack)
      interval = style ? style.apply(star_mappings, graphmaster, predicates, category_stack) : 'years'
      result = TimeDifference.between(Date.parse(formatted_from, format), Date.parse(formatted_to, format)).send("in_#{interval}").to_i
    end

    result
  end

  def format
    self.attributes['format'] || '%B %d, %Y'
  end
end
