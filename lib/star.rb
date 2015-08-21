class Star < GraphmasterNode
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    index = (attributes['index'] || 1).to_i
    star_mapping = star_mappings[index-1]
    if (star_mapping)
      star_mapping[1].join(' ')
    else
      nil
    end
  end

end
