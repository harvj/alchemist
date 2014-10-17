class Deck < ActiveRecord::Base

  has_many :cards, class_name: 'DeckCard'

  def has_available?(combo)
    cards.where(card_id: combo.card.id).any? && cards.where(card_id: combo.match.id).any?
  end

end
