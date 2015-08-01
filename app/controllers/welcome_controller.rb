class WelcomeController < ApplicationController

  after_filter :persist_chat

  def index
    if (input = params[:input])
      @response = Interactors::QueryBot.new(@request).call
      output = @response[:output]
    end
  end

  def reset
    @chat.clear
    redirect_to :root
  end

  private 

  def persist_chat
    @chat_session.update_attributes(chat_json: @chat.to_json)
  end
end
