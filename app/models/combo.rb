class Combo < ActiveRecord::Base

  TIERS = {
    first: 57.0,
    second: 45.0,
    third: 37.0,
    fourth: 27.0
  }

  belongs_to :card
  belongs_to :match, class_name: 'Card'
  belongs_to :final, class_name: 'Card'

  validates_presence_of :card_id, :match_id, :final_id

  def offense_for_level(level)
    final.base_offense + (dominant_multiplier * (level - 1))
  end

  def defense_for_level(level)
    final.base_defense + (dominant_multiplier * (level - 1))
  end

  def dominant_multiplier
    [card.multiplier, match.multiplier].max
  end

  def offensive_adjustment
    base = offense_for_level(5)
    base > 24 ? (1.04 + ((base - 25) / 80.0)) : 1
  end

  def defensive_adjustment
    base = defense_for_level(5)
    base > 24 ? (1.11 + ((base - 25) / 80.0)) : 1
  end

  def calculate_score
    (offense_for_level(5) * offensive_adjustment) * (defense_for_level(5) * defensive_adjustment) / 10
  end

  def calculate_score!
    self.score = calculate_score
    save!
  end

end
