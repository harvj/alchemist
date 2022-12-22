class Combo < ApplicationRecord

  TIERS = {
    first: 70.5,
    second: 58.9,
    third: 37.0,
    fourth: 27.0
  }

  belongs_to :card
  belongs_to :match, class_name: 'Card'
  belongs_to :final, class_name: 'Card'

  belongs_to :partner, class_name: 'Combo'

  validates_presence_of :card_id, :match_id, :final_id

  after_save :assign_partner

  def stat_for_level(type, level, options={})
    if options[:onyx]
      final.send("base_#{type}") + final.adjustment[:onyx]
    else
      final.send("base_#{type}") + (dominant_multiplier * (level - 1))
    end
  end

  def dominant_multiplier
    [card.adjustment[:combo], match.adjustment[:combo]].max
  end

  def offensive_adjustment(options={})
    base = stat_for_level(:offense, 6, options)
    base > 28 ? (1.04 + ((base - 28) / 80.0)) : 1
  end

  def defensive_adjustment(options={})
    base = stat_for_level(:defense, 6, options)
    base > 26 ? (1.08 + ((base - 25) / 80.0)) : 1
  end

  def calculate_score(options={})
    (stat_for_level(:offense, 6, options) * offensive_adjustment(options)) * (stat_for_level(:defense, 6, options) * defensive_adjustment(options)) / 10
  end

  def calculate_score!
    self.score = calculate_score
    self.onyx_score = calculate_score(onyx: true)
    save!
  end

  private

  def assign_partner
    return if partner.present?
    partner = Combo.where(match_id: card_id, card_id: match_id).first || Combo.create!(match_id: card_id, card_id: match_id, final_id: final_id, partner: self)
    self.update(partner_id: partner.id)
  end

end
