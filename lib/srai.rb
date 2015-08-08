class Srai 
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    result = nil
    pattern = super(path_match_result, graphmaster, predicates).strip
    next_path_match_result = PathMatcher.new.get_matching_path(graphmaster, pattern, predicates['_chat_session_id'])

    # TODO: Possible code smells revealed here: 1) chaining, 2) called method on object and passing same object as parameter.
    next_path_match_result.path.last.apply(next_path_match_result, graphmaster, predicates)
  end

end
