class Uppercase
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    super.upcase
  end

end
