class Combo < ActiveRecord::Base

  TIERS = {
    first: 43.0,
    second: 40.0,
    third: 37.0,
    fourth: 34.0
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

  def calculate_score
    offense_for_level(5) + (defense_for_level(5) * 0.85)
  end

  def calculate_score!
    self.score = calculate_score
    save!
  end

end
