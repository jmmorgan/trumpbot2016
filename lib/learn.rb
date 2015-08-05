class Learn
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    eval(tokens, path_match_result, graphmaster, predicates)
    # For now we will append to learned categories in predicates
    predicates['_learned_categories'] ||= []
    tokens.each do |token|
      predicates['_learned_categories'] << token.raw_xml
    end
    nil
  end

  private 

  def eval(tokens, path_match_result, graphmaster, predicates)
    tokens.each_index do |i|
      token = tokens[i]
      if (token.is_a?(Eval))
        tokens[i] = token.apply(path_match_result, graphmaster, predicates)
      elsif (token.is_a?(TemplateContentNode))
        eval(token.tokens, path_match_result, graphmaster, predicates)
      end
    end
  end

end
