class AimlMap
  include TemplateContentNode

  attr_accessor :name, :map

  def apply(star_mappings, graphmaster, predicates, category_stack)
    name = attributes['name']
    if (name)
      result = map(name)[tokens.first.apply(star_mappings, graphmaster, predicates, category_stack)]
    else
      name = tokens[0].apply(star_mappings, graphmaster, predicates, category_stack)
      result = map(name)[tokens[1].apply(star_mappings, graphmaster, predicates, category_stack)]
    end

    result
  end

  private

  def name(star_mappings, graphmaster, predicates, category_stack)
    @name ||= load_name(star_mappings, graphmaster, predicates, category_stack)
  end

  def load_name(star_mappings, graphmaster, predicates, category_stack)
    result = attributes[name]
    unless result
      # pluck name from first token 
      result = tokens.shift.apply(star_mappings, graphmaster, predicates, category_stack)
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
