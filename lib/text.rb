require 'graphmaster_node'

class Text < GraphmasterNode
  attr_accessor :value

  def initialize(value = '')
    @value = value
    super()
  end

  def ==(other)
    return other.is_a?(Text) && other.value == @value
  end

  def to_s
    @value
  end
  
end
