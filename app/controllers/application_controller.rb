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
    @request[:chat] = Chat.new
    # TODO: Need to persist Chat across session
  end
end
