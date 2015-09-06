class Think
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    tokens.each{|token| token.apply(star_mappings, graphmaster, predicates, category_tree.branch) if token.respond_to?(:apply)}

    nil
  end

end
