class TemplateGet
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    # TODO: Remove global constant reference (maybe merge default-xxx into predicates?)
    predicates[attributes['var'] || attributes['name']] || PROPERTIES_MAP_FILE['default-get']
  end

end
