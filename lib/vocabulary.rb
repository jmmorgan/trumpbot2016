class Vocabulary
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    graphmaster.word_nodes.count
  end

end

