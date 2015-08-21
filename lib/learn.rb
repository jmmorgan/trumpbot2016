class Learn
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    copy = deep_clone # clone this node so we can do eval transforms inside categories without affectong
                      # contents of this node
    eval(copy.tokens, star_mappings, graphmaster, predicates, category_stack)
    # For now we will append to learned categories in predicates
    predicates['_learned_categories'] ||= []
    copy.tokens.each do |token|
      predicates['_learned_categories'] << token.raw_xml
    end
    nil
  end

  private 

  def eval(tokens, star_mappings, graphmaster, predicates, category_stack)
    tokens.each_index do |i|
      token = tokens[i]
      if (token.is_a?(Eval))
        tokens[i] = token.apply(star_mappings, graphmaster, predicates, category_stack)
      elsif (token.is_a?(TemplateContentNode))
        eval(token.tokens, star_mappings, graphmaster, predicates, category_stack)
      end
    end
  end

end
