class ChatResponse
  attr_accessor :outputs, :inputs, :matched_patterns, :source_files

  def initialize(bot_brain_response)
    @outputs = bot_brain_response[:responses]
    @inputs = bot_brain_response[:inputs]
    @matched_patterns = bot_brain_response[:matched_patterns]
    @source_files = bot_brain_response[:source_files]
  end

  def [](key)
    self.send(key)
  end
end
