class Think
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_stack)
    tokens.each{|token| token.apply(star_mappings, graphmaster, predicates, category_stack) if token.respond_to?(:apply)}

    nil
  end

end
