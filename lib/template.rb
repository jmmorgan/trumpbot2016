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

  # Applies this template to the given PathMatchResult and Graphmaster and returns
  # a normalized response.
  def apply(path_match_result, graphmaster)
    result = tokens.map{|token| token.is_a?(String) ? token : token.apply(path_match_result, graphmaster)}.join(' ')
  end
end
