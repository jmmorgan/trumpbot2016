module Parsers
  class ThatXmlParser

    def parse(that_element)
      that = That.new
      that.expression = that_element ? that_element.content : '*'
      that
    end
  end
end
