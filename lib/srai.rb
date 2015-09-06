class Srai 
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    result = nil
    pattern = super(star_mappings, graphmaster, predicates, category_tree).strip
    next_path_match_result = PathMatcher.new.get_matching_path(graphmaster, pattern, predicates['_chat_session_id'])

    if (next_path_match_result)
      next_path_match_result.apply_template(predicates, category_tree)
    else
      nil
    end
  end

end
