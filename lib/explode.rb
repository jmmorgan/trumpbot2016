class Explode
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    super.chars.join(' ')
  end

end
