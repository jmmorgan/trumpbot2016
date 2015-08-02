class Srai 
  include TemplateContentNode

  def apply(path_match_result, graphmaster)
    result = nil
    pattern = tokens.collect{|token| token.is_a?(String) ? token : token.apply(path_match_result, graphmaster)}.join(' ')
    next_path_match_result = PathMatcher.new.get_matching_path(graphmaster, pattern)

    # TODO: Possible code smells revealed here: 1) chaining, 2) called method on object and passing same object as parameter.
    next_path_match_result.path.last.apply(next_path_match_result, graphmaster)
  end

  private 

end
