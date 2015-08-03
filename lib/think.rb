class Think
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    tokens.each{|token| token.apply(path_match_result, graphmaster, predicates) if token.respond_to?(:apply)}

    nil
  end

end
