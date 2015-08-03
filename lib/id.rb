class Id
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    predicates['id'] || '127.0.0.1'
  end

end
