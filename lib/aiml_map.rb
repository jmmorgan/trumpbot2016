class AimlMap
  include TemplateContentNode

  attr_accessor :name, :map

  def apply(path_match_result, graphmaster, predicates)
    name = attributes['name']
    if (name)
      result = map(name)[tokens.first.apply(path_match_result, graphmaster, predicates)]
    else
      name = tokens[0].apply(path_match_result, graphmaster, predicates)
      result = map(name)[tokens[1].apply(path_match_result, graphmaster, predicates)]
    end

    result
  end

  private

  def name(path_match_result, graphmaster, predicates)
    @name ||= load_name(path_match_result, graphmaster, predicates)
  end

  def load_name(path_match_result, graphmaster, predicates)
    result = attributes[name]
    unless result
      # pluck name from first token 
      result = tokens.shift.apply(path_match_result, graphmaster, predicates)
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
