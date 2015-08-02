class TemplateGet
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    predicates[attributes['var']] || '*'
  end

end
