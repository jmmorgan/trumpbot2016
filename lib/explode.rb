class Explode
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    super.chars.join(' ')
  end

end
