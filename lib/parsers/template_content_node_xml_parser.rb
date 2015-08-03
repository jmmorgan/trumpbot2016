module Parsers
  class TemplateContentNodeXmlParser

    def parse(template_content_node_element, template_content_node_class = Template)
      template_content_node = template_content_node_class.new
      if (template_content_node_element)
        template_content_node.raw_xml = template_content_node_element.children.to_s
        template_content_node.tokens = parse_tokens(template_content_node_element.children)
        template_content_node.attributes = to_attributes(template_content_node_element.attributes)
      end
      template_content_node
    end

    private

    def parse_tokens(nodes)
      tokens = []
      nodes.each do |node|
        if (node.text?)
          tokens += node.content.split.collect{|token| to_text_node(token)}
        else
          name = node.name
          template_content_node_class = TEMPLATE_CONTENT_NODE_MAP[name] || Template
          tokens << TemplateContentNodeXmlParser.new.parse(node, template_content_node_class)
        end
      end

      tokens
    end

    def to_text_node(token)
      return token # TODO: Do we need to wrap this?
    end

    def to_attributes(element_attributes)
      element_attributes.inject({}) do |memo, attribute|
        memo[attribute[1].name] = attribute[1].value
        memo
      end
    end


    TEMPLATE_CONTENT_NODE_MAP = {
      'template' => Template,
      'srai' => Srai,
      'sr' => Srai, 
      'bot' => AimlBot,
      'random' => AimlRandom,
      'think' => Think,
      'condition' => Condition,
      'interval' => Interval,
      'from' => From,
      'to' => To,
      'style' => Style,
      'size' => Size,
      'vocabulary' => Vocabulary,
      'star' => Star,
      'get' => TemplateGet,
      'set' => TemplateSet,
      'formal' => Formal,
      'learn' => Learn,
      'eval' => Eval,
      'lowercase' => Lowercase,
      'uppercase' => Uppercase,
      'explode' => Explode,
      'date' => AimlDate,
      'map' => AimlMap,
      'person' => Person,
      'input' => Input,
      'a' => Anchor,
      'id' => Id,
      'br' => LineBreak,
      'get_likes' => GetLikes,
      'request' => AimlRequest,
      'response' => AimlResponse,
      'that' => That,
      'normalize' => Normalize,
      'item' => Item,
      'first' => First
    }
  end
end
