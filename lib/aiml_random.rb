class AimlRandom
  include TemplateContentNode

  def apply(path_match_result, graphmaster)
    tokens.sample.apply(path_match_result, graphmaster)
  end

end
