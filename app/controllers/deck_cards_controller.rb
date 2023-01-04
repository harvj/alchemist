class DeckCardsController < ApplicationController
  def create
    deck = Deck.find(params[:deck_id])
    DeckCard.create!(deck_id: params[:deck_id], card_id: params[:card_id], fused: params[:fused], level: params[:level], rarity: params[:rarity])
    redirect_to deck_path(deck)
  end

  def destroy
    deck = Deck.find(params[:deck_id])
    deck_card = deck.deck_cards.find_by(id: params[:id])
    deck_card.destroy
    redirect_to deck_path(deck)
  end
end
