class Anchor
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    "<a #{attributes.collect{|(key,val)| "#{key}=\"#{val}\""}.join(' ')}>#{super}</a>"
  end

end
