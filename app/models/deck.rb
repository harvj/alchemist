class Deck < ActiveRecord::Base

  has_many :deck_cards
  has_many :cards, through: :deck_cards

  def has_available?(combo)
    cards.where(id: combo.match.id).any?
  end

end
