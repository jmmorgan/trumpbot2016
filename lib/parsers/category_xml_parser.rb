module Parsers
  class CategoryXmlParser

    def parse(category_element)
      category = Category.new
      category.pattern = Parsers::PatternXmlParser.new.parse(category_element.xpath('pattern').first)
      category
    end

  end
end