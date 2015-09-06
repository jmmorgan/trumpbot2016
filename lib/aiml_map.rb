class AimlMap
  include TemplateContentNode

  attr_accessor :name, :map

  def apply(star_mappings, graphmaster, predicates, category_tree)
    name = attributes['name']
    if (name)
      result = map(name)[tokens.first.apply(star_mappings, graphmaster, predicates, category_tree)]
    else
      name = tokens[0].apply(star_mappings, graphmaster, predicates, category_tree)
      result = map(name)[tokens[1].apply(star_mappings, graphmaster, predicates, category_tree)]
    end

    result
  end

  private

  def name(star_mappings, graphmaster, predicates, category_tree)
    @name ||= load_name(star_mappings, graphmaster, predicates, category_tree)
  end

  def load_name(star_mappings, graphmaster, predicates, category_tree)
    result = attributes[name]
    unless result
      # pluck name from first token 
      result = tokens.shift.apply(star_mappings, graphmaster, predicates, category_tree)
    end
  end


  def map(name)
    (@@map ||= {})[name] ||= load_map(name)
  end

  def load_map(name)
    # Load map files
    MapFile.new("#{Rails.root}/lib/maps/#{name}.map")
  end
end
