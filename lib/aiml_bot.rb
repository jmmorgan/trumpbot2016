class AimlBot < GraphmasterNode
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    # For now we're accessing a global constant.
    # TODO: Make this a little more encapsulated/object-oriented?
    (PROPERTIES_MAP_FILE[attributes['name']] || '*').strip
  end

  def ==(other)
    return other.is_a?(AimlBot) && other.attributes == attributes
  end
end
