module TemplateContentNode
  attr_accessor :raw_xml, :tokens, :attributes

  # Applies this template to the given PathMatchResult, Graphmaster predicates and returns
  # a normalized response.
  #
  # Classes including this module should override this method to return a normalized response 
  # fragment, or nil when appropriate.
  def apply(path_match_result, graphmaster, predicates)
    #puts "self.class = #{self.class} #{tokens.to_s}" # For debugging for now
    result = tokens.map{|token| token.is_a?(String) ? token : token.apply(path_match_result, graphmaster, predicates)}.join(' ')
  end

end
