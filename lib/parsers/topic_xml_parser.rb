module Parsers
  class TopicXmlParser

    def parse(topic_element)
      topic = That.new
      topic.expression = topic_element ? topic_element.content : '*'
      topic
    end
  end
end
