module Parsers
  class ThatXmlParser

    def parse(that_element)
      that = That.new
      that.expression = that_element ? that_element.content : nil
      that
    end
  end
end
