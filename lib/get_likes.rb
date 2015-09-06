class GetLikes
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    predicates['likes'] || 'chatting with me'
  end

end
