class UsersController < ApplicationController
  def show
    @movements = User.find(params[:id]).movements
  end
end