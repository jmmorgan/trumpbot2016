class Topic < GraphmasterNode
  attr_accessor :expression

  def ==(other_object)
    return other_object.is_a?(Topic) && other_object.expression == @expression
  end

  def to_regex
    ''
  end
end
