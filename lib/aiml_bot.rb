class AimlBot < GraphmasterNode
  attr_accessor :name

  def ==(other)
    return other.is_a?(AimlBot) && other.name == @name
  end
end
