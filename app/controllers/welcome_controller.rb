class WelcomeController < ApplicationController

  def index
    if (input = params[:input])
      output = "That's a good question"
      session[:inputs] ||= []
      session[:outputs] ||= []
      session[:inputs] << input
      session[:outputs] << output
    end
  end

  def reset
    session[:inputs] = []
    session[:outputs] = []
    redirect_to :root
  end
end
