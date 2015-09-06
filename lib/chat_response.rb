class ChatResponse
  attr_accessor :outputs, :inputs, :category_trees, :source_files, :that

  def initialize(bot_brain_response, predicates)
    @outputs = bot_brain_response[:responses]
    @inputs = bot_brain_response[:inputs]
    @category_trees = bot_brain_response[:category_trees]
    @source_files = bot_brain_response[:source_files]
    @that = predicates['that']
  end

  def [](key)
    self.send(key)
  end
end
