class Topic < GraphmasterNode
  attr_accessor :expression

  def initialize(expression = '*')
    @expression = expression
    super()
  end

  def ==(other_object)
    return other_object.is_a?(Topic) && other_object.expression == @expression
  end

  def matching_tokens(input_tokens, next_node, that = '*', topic = '*')
    []
  end
end
