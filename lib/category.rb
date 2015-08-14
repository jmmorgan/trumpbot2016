class Category
  attr_accessor :pattern, :that, :topic, :template, :source_file

  def initialize(pattern, that, topic, template, source_file = nil)
    @pattern = pattern
    @that = that
    @topic = topic
    @template = template
    @source_file = source_file
  end
end
