module Parsers
  class BotXmlParser

    def parse(bot_element)
      bot = AimlBot.new
      bot.name = bot_element.content
      bot
    end
  end
end
