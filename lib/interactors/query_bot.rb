class Interactors::QueryBot < Interactor

  def call
    chat = @request[:chat] ||= Chat.new(nil)
    chat_response = chat.respond(@request[:input])
    chat_response
  end
end
