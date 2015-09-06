class AimlRandom
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    tokens.sample.apply(star_mappings, graphmaster, predicates, category_tree)
  end

end
