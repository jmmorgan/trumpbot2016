class TemplateSet
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    var = attributes['var']
    if (var)
      predicates[var] = super(path_match_result, graphmaster, predicates)
    end
    
    nil
  end

end
