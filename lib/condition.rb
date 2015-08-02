class Condition
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    result = match_var(path_match_result, graphmaster, predicates) || 
      match_name(path_match_result, graphmaster, predicates)
   
    result
  end

  private

  def match_var(path_match_result, graphmaster, predicates)
    result = nil
    var = attributes['var']
    if (var)
      # Assuming for now we are iteration through li elements
      tokens.each do |node|
        test_value = node.attributes['value']
        if (test_value == predicates[var] || test_value.nil?)
          result = node.apply(path_match_result, graphmaster, predicates)
          break
        end
      end
    end

    result
  end

  def match_name(path_match_result, graphmaster, predicates)
    result = nil
    name = attributes['name']
    if (name)
      # Assuming for now we are iteration through li elements
      tokens.each do |node|
        test_value = node.attributes['value']
        if (test_value == PROPERTIES_MAP_FILE[name] || test_value.nil?)
          result = node.apply(path_match_result, graphmaster, predicates)
          break
        end
      end
    end

    result
  end
end
