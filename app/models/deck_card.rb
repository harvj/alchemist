class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card

  enum :rarity, Card::RARITIES

  validates :deck_id, :card_id, :level, :rarity, presence: true

  delegate :name, :base_offense, :base_defense, :display_name, :adjustment, to: :card

  def offense
    base_offense + (adjustment[:combo] * (level - 1))
  end

  def defense
    base_offense + (adjustment[:combo] * (level - 1))
  end

  def badge_display
    (fused? ? 'F' : level.to_s).html_safe
  end

  def badge_class
    if fused?
      'fused'
    elsif rarity == 'onyx'
      'onyx'
    else
      'level-'+level.to_s
    end.html_safe
  end
end
