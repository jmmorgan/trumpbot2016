class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :build_request

  protected

  def build_request
    r = Request.new
    r.merge!(params)
    @request = r.with_indifferent_access
    # Initializing chat here for now.
    @chat_session = ChatSession.find_or_create_by(session_id: session.id)
    @request[:chat] = (@chat_session.chat : Chat.new(@chat_session.id))
  end
end
