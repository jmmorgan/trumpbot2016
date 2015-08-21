class TemplateSet
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)

    result = nil
    var = attributes['var'] || attributes['name']
    if (var)
      result = (predicates[var] = super(star_mappings, graphmaster, predicates, category_stack))
    end
    
    result
  end

end
