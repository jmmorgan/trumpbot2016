class WelcomeController < ApplicationController

  after_filter :persist_chat

  def index
    if (input = params[:input])
      @response = Interactors::QueryBot.new(@request).call
      output = @response[:output]
    end
  end

  def reset
    # Clear chat session ID so new chat will be created (and old one will be preserved in database)
    session[:chat_session_id] = nil
    redirect_to :root
  end

  def download
    send_data @chat.transcript, filename: 'conversation.txt'
  end

  private 

  def persist_chat
    @chat_session.update_attributes(chat_json: @chat.to_json)
  end
end
