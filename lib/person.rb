class Person
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    input = nil
    if (tokens.present?)
      input = super(star_mappings, graphmaster, predicates, category_tree)
    else
      index = (attributes['index'] || 1).to_i
      star_mapping = star_mappings.star_mappings[index-1]
      if (star_mapping)
        input = star_mapping[1].join(' ')
      end
    end

    # TODO: See if substitutions are necessary as we flesh out categories
    input
  end

end
