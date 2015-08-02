class TemplateSet
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)

    result = nil
    var = attributes['var'] || attributes['name']
    if (var)
      result = (predicates[var] = super(path_match_result, graphmaster, predicates))
    end
    
    result
  end

end
