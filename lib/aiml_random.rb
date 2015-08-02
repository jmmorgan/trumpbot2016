class AimlRandom
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    tokens.sample.apply(path_match_result, graphmaster, predicates)
  end

end
