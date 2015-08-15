module Parsers
  class ThatXmlParser

    def parse(that_element)
      That.new(that_element ? that_element.content : '*')
    end
  end
end
