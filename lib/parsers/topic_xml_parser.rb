module Parsers
  class TopicXmlParser

    def parse(topic_element)
      Topic.new(topic_element ? topic_element.content : '*')
    end
  end
end
