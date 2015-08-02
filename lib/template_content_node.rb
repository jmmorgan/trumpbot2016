module TemplateContentNode
  attr_accessor :raw_xml, :tokens, :attributes

  # Classes including this module should override this method to return a normalized response 
  # fragment, or nil when appropriate.
  def apply(path_match_result, graphmaster)
    @raw_xml
  end

end
