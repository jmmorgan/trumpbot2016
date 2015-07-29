class AimlSet < GraphmasterNode
  attr_accessor :name

  def ==(other)
    return other.is_a?(AimlSet) && other.name == @name
  end

end
