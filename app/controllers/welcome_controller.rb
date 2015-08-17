class WelcomeController < ApplicationController

  after_filter :persist_chat

  def index
    
  end

  def talk
    if ((input = params[:input]) && !input.blank?)
      @response = Interactors::QueryBot.new(@request).call
    end
  end

  def reset
    # Clear chat session ID so new chat will be created (and old one will be preserved in database)
    session[:chat_session_id] = nil
    redirect_to :root
  end

  def download
    send_data @chat_session.transcript, filename: 'conversation.txt'
  end

end
