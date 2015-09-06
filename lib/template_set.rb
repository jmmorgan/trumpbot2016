class TemplateSet
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)

    result = nil
    var = attributes['var'] || attributes['name']
    if (var)
      result = (predicates[var] = super(star_mappings, graphmaster, predicates, category_tree))
    end
    
    result
  end

end
