class Uppercase
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    super.upcase
  end

end
