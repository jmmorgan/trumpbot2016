class Star < GraphmasterNode
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    index = (attributes['index'] || 1).to_i
    star_mapping = path_match_result.star_mappings[index-1]
    if (star_mapping)
      star_mapping[1].join(' ')
    else
      nil
    end
  end

end
