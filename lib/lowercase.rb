class Lowercase
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    super.downcase
  end

end
