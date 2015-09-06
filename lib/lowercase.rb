class Lowercase
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    super.downcase
  end

end
