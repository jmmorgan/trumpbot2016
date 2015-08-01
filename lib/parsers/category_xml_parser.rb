module Parsers
  class CategoryXmlParser

    def parse(category_element)
      category = Category.new
      category.pattern = Parsers::PatternXmlParser.new.parse(category_element.xpath('pattern').first)
      category.that =  Parsers::ThatXmlParser.new.parse(category_element.xpath('that').first)
      category.topic = Topic.new # for now
      category.template = Parsers::TemplateContentNodeXmlParser.new.parse(category_element.xpath('template').first)
      category
    end

  end
end
