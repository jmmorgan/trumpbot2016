class Template < GraphmasterNode
  attr_accessor :raw_xml # for now

  def ==(other_object)
    return other_object.is_a?(Template) && other_object.raw_xml == @raw_xml
  end

  def to_s
    "<template>#{@raw_xml}"
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end

end
