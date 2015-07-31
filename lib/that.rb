class That < GraphmasterNode
  attr_accessor :expression

  def ==(other_object)
    return other_object.is_a?(That) && other_object.expression == @expression
  end

  def priority
    8
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    input_tokens.empty? && (that == self.expression) ? [] : nil
  end

  def to_s
    "<that>#{self.expression}"
  end
end
