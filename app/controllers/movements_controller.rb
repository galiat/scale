class MovementsController < ApplicationController
  def index
    @movements = current_user.movements
  end
end