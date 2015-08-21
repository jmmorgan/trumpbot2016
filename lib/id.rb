class Id
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    predicates['id'] || '127.0.0.1'
  end

end
