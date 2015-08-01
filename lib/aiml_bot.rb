class AimlBot < GraphmasterNode
  include TemplateContentNode
  attr_accessor :name

  def ==(other)
    return other.is_a?(AimlBot) && other.name == @name
  end
end
