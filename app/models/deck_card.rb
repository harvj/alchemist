class DeckCard < ActiveRecord::Base

  belongs_to :deck
  belongs_to :card

  delegate :name, :base_offense, :base_defense, :color, :display_name, :multiplier, to: :card

  def offense
    base_offense + (multiplier * (level - 1))
  end

  def defense
    base_offense + (multiplier * (level - 1))
  end

  def badge_display
    (fused? ? 'F' : level.to_s).html_safe
  end

  def badge_class
    (fused? ? 'fused' : 'level-'+level.to_s).html_safe
  end

end
