class Condition
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    result = match_var(star_mappings, graphmaster, predicates, category_stack) || 
      match_name(star_mappings, graphmaster, predicates, category_stack)
   
    result
  end

  private

  def match_var(star_mappings, graphmaster, predicates, category_stack)
    result = nil
    var = attributes['var']
    if (var)
      # Assuming for now we are iteration through li elements
      tokens.each do |node|
        test_value = node.attributes['value']
        if (test_value == predicates[var] || test_value.nil?)
          result = node.apply(star_mappings, graphmaster, predicates, category_stack)
          break
        end
      end
    end

    result
  end

  def match_name(star_mappings, graphmaster, predicates, category_stack)
    result = nil
    name = attributes['name']
    if (name)
      # Assuming for now we are iteration through li elements
      tokens.each do |node|
        test_value = node.attributes['value']
        if (test_value == PROPERTIES_MAP_FILE[name] || test_value.nil?)
          result = node.apply(star_mappings, graphmaster, predicates, category_stack)
          break
        end
      end
    end

    result
  end
end
