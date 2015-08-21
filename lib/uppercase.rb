class Uppercase
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    super.upcase
  end

end
