class Person
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    input = nil
    if (tokens.present?)
      input = super(path_match_result, graphmaster, predicates)
    else
      index = (attributes['index'] || 1).to_i
      star_mapping = path_match_result.star_mappings[index-1]
      if (star_mapping)
        input = star_mapping[1].join(' ')
      end
    end

    # TODO: See if substitutions are necessary as we flesh out categories
    input
  end

end
