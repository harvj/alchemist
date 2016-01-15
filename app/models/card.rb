class Card < ActiveRecord::Base

  validates_uniqueness_of :name, scope: :color

  has_many :combos
  has_many :deck_cards

  scope :combo, -> { where(classification: 'combo') }

  def combos
    super.includes(:final, :match)
  end

  def display_name
    name.titleize
  end

  def final?
    classification == 'final'
  end

  def adjustment
    case color
    when 'diamond'
      {combo: 4, onyx: 20}
    when 'gold'
      {combo: 3, onyx: 23}
    when 'silver'
      {combo: 2, onyx: 25}
    when 'bronze'
      {combo: 1, onyx: 27}
    end
  end

  def calculate_score
    first_tier_combos  = combos.to_a.delete_if{|c| c.score <= Combo::TIERS[:first]}
    second_tier_combos = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:first] || c.score <= Combo::TIERS[:second]}
    third_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:second] || c.score <= Combo::TIERS[:third]}
    fourth_tier_combos  = combos.to_a.delete_if{|c| c.score > Combo::TIERS[:third] || c.score <= Combo::TIERS[:fourth]}
    first_tier_combos.count * 1000 + second_tier_combos.count * 100 + third_tier_combos.count * 10 + fourth_tier_combos.count
  end

  def calculate_score!
    self.score = calculate_score
    save!
  end

end
