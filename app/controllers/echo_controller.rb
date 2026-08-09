class EchoController < ApplicationController
  def create
    render json: { message: params[:message] }
  end
end
