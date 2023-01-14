class Combo < ApplicationRecord
  TIERS = {
    first: 70.5,
    second: 58.9,
    third: 37.0,
    fourth: 27.0
  }

  enum card_rarity: RARITIES, _prefix: true
  enum match_rarity: RARITIES, _prefix: true
  enum final_rarity: RARITIES, _prefix: true
  enum high_rarity: RARITIES, _prefix: true

  belongs_to :card
  belongs_to :match, class_name: 'Card'
  belongs_to :final, class_name: 'Card'
  belongs_to :partner, class_name: 'Combo'

  validates :card_id, :match_id, :final_id, presence: true

  after_save :assign_partner

  private

  def assign_partner
    return if partner.present?
    partner = Combo.where(match_id: card_id, card_id: match_id).first || Combo.create!(match_id: card_id, card_id: match_id, final_id: final_id, partner: self)
    self.update(partner_id: partner.id)
  end
end
