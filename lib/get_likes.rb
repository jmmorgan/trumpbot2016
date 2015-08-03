class GetLikes
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    predicates['likes'] || 'chatting with me'
  end

end
