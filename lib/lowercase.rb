class Lowercase
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    super.downcase
  end

end
