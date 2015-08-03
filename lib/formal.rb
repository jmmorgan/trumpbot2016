class Formal
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    super.titlecase
  end

end
