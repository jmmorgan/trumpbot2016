class Interactors::QueryBot < Interactor

  def call
    chat = @request[:chat] ||= Chat.new(nil))
    @response[:chat] = chat
    @response[:output] = chat.respond(@request[:input])
    @response
  end
end
