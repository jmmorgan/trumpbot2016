module Parsers
  class CategoryXmlParser

    def parse(category_element, source_file = nil)
      pattern = Parsers::PatternXmlParser.new.parse(category_element.xpath('pattern').first)
      that =  Parsers::ThatXmlParser.new.parse(category_element.xpath('that').first)
      topic = Topic.new('*') # for now
      template = Parsers::TemplateContentNodeXmlParser.new.parse(category_element.xpath('template').first)
      Category.new(pattern, that, topic, template, source_file)
    end

  end
end
