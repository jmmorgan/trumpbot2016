module Parsers
  class SetXmlParser

    def parse(set_element)
      set = AimlSet.new
      set.name = set_element.content
      set
    end
  end
end
