class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    @movements = @user.movements
  end
end