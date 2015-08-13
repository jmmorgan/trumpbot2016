class ChatResponse
  attr_accessor :outputs, :inputs, :matched_patterns

  def initialize(bot_brain_response)
    @outputs = bot_brain_response[:responses]
    @inputs = bot_brain_response[:inputs]
    @matched_patterns = bot_brain_response[:matched_patterns]
  end
end
