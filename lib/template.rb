class Template < GraphmasterNode
  include TemplateContentNode

  def ==(other_object)
    return other_object.is_a?(Template) && other_object.raw_xml == @raw_xml
  end

  def to_s
    "<template>#{@raw_xml}"
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end

  # Applies this template to the given Chat and Graphmaster and returns
  # a normalized response.
  def apply(chat, graphmaster)
    tokens.map{|token| token.is_a?(String) ? token : token.apply(chat, graphmaster)}.join(' ')
  end
end
