class AimlRandom
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    tokens.sample.apply(star_mappings, graphmaster, predicates, category_stack)
  end

end
