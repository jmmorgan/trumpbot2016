class Size
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    graphmaster.size
  end

end
