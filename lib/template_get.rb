class TemplateGet
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    # TODO: Remove global constant reference (maybe merge default-xxx into predicates?)
    key = attributes['var'] || attributes['name']
    predicates[key] || PROPERTIES_MAP_FILE["default-#{key}"] || PROPERTIES_MAP_FILE["default-get"]
  end

end
