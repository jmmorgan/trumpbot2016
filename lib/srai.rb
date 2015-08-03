class Srai 
  include TemplateContentNode

  def apply(path_match_result, graphmaster, predicates)
    puts "RAWXML = #{raw_xml}"
    result = nil
    pattern = super(path_match_result, graphmaster, predicates)
    next_path_match_result = PathMatcher.new.get_matching_path(graphmaster, pattern)

    # TODO: Possible code smells revealed here: 1) chaining, 2) called method on object and passing same object as parameter.
    next_path_match_result.path.last.apply(next_path_match_result, graphmaster, predicates)
  end

  private 

end
