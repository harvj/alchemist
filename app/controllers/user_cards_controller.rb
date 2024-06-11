class UserCardsController < ApplicationController
  def create
    UserCard.create(user_card_params)
  end

  private

  def user_card_params
    params.require(:user_card).permit(:user_id, :card_id)
  end
end
