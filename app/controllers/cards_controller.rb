class CardsController < ApplicationController
  def index
    @cards = Card.combo.where("id NOT IN (select card_id from user_cards where user_id = ?)", current_user.id).order(:name)
  end

  def show
    @card = Card.find(params[:id])
    @current_deck_combos = @card.combos(deck_id: current_deck.id, user_id: current_user.id, sort: combo_sort)
  end

   def update
    @card = Release.find(params[:id])
    if @card.update_attributes!(params[:card])
      respond_to do |format|
        format.json { render json: {status: :ok} }
      end
    end
  end
end
