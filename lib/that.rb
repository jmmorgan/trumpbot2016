class That < GraphmasterNode
  attr_accessor :expression

  def ==(other_object)
    return other_object.is_a?(That) && other_object.expression == @expression
  end
end
