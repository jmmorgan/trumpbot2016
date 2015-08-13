class Category
  attr_accessor :pattern, :that, :topic, :template

  def initialize(pattern, that, topic, template)
    @pattern = pattern
    @that = that
    @topic = topic
    @template = template
  end
end
