module TemplateContentNode
  attr_accessor :raw_xml, :tokens

  # Classes including this module should override this method to return a normalized response 
  # fragment, or nil when appropriate.
  def apply(chat, graphmaster)
    @raw_xml
  end

end
