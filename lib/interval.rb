class Interval
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    reult = nil
    from = tokens.select{|token| token.is_a?(From)}.first
    to = tokens.select{|token| token.is_a?(To)}.first
    style = tokens.select{|token| token.is_a?(Style)}.first
    if (from && to)
      formatted_from = from.apply(path_match_result, graphmaster, predicates)
      formatted_to = to.apply(path_match_result, graphmaster, predicates)
      interval = style ? style.apply(path_match_result, graphmaster, predicates) : 'years'
      result = TimeDifference.between(Date.parse(formatted_from, format), Date.parse(formatted_to, format)).send("in_#{interval}").to_i
    end

    result
  end

  def format
    self.attributes['format'] || '%B %d, %Y'
  end
end
