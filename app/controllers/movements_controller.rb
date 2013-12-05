class MovementsController < ApplicationController
  def index
    @movements = current_user.try(:movements)
  end
end