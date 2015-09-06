class Anchor
  include TemplateContentNode

  def apply(star_mappings, graphmaster, predicates, category_tree)
    "<a #{attributes.collect{|(key,val)| "#{key}=\"#{val}\""}.join(' ')}>#{super}</a>"
  end

end
