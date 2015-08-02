# TODO: We can probably eliminate the need for this class with a refactor or PatternXmlParser
module Parsers
  class BotXmlParser < TemplateContentNodeXmlParser

    def parse(bot_element)
      super(bot_element, AimlBot)
    end
  end
end
