class Condition
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
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
end
