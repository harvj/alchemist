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
  enum fusion: FUSIONS

  belongs_to :card
  belongs_to :match, class_name: 'Card'
  belongs_to :final, class_name: 'Card'
  belongs_to :partner, class_name: 'Combo'

  validates :card_id, :match_id, :final_id, presence: true

  after_save :assign_partner

  def researched?
    researched.present?
  end

  private

  def assign_partner
    return if partner.present?
    partner = Combo.where(match_id: card_id, card_id: match_id).first || Combo.create!(match_id: card_id, card_id: match_id, final_id: final_id, partner: self)
    self.update(partner_id: partner.id)
  end

  def self.with_stats
    Combo.find_by_sql(<<~SQL
      select x.card_rarity,
        x.card_name,
        x.match_rarity,
        x.match_name,
        x.final_rarity,
        x.final_name,
        base_offense + modifier + (5 * rarity_multiplier) as final_offense,
        base_defense + modifier + (5 * rarity_multiplier) as final_defense,
        base_offense + modifier + (5 * rarity_multiplier) + base_defense + modifier + (5 * rarity_multiplier) as power
      from
      (
      select
        combos.card_id,
        cards.name as card_name,
        cards.rarity as card_rarity,
        matches.id as match_id,
        matches.name as match_name,
        matches.rarity as match_rarity,
        finals.name as final_name,
        finals.rarity as final_rarity,
        0 as modifier,
        finals.base_offense,
          finals.base_defense,
          greatest(cards.rarity, matches.rarity) + 1 as rarity_multiplier
      from combos
      join cards on combos.card_id = cards.id
      join cards matches on combos.match_id = matches.id
      join cards finals on combos.final_id = finals.id
      where cards.id IN (select card_id from user_cards) AND matches.id IN (select card_id from user_cards)
      union all
      select
        combos.card_id,
        cards.name as card_name,
        4 as card_rarity,
        matches.id as match_name,
        matches.name as match_name,
        matches.rarity as match_rarity,
        finals.name as final_name,
        3 as final_rarity,
        (case when finals.rarity = 0 then 7
                when finals.rarity = 1 then 5
                when finals.rarity = 2 then 3 else 0 end) as modifier,
          finals.base_offense,
          finals.base_defense,
          4 as rarity_multiplier
      from combos
      join cards on combos.card_id = cards.id
      join cards matches on combos.match_id = matches.id
      join cards finals on combos.final_id = finals.id
      where cards.id IN (select card_id from user_cards where onyx IS TRUE) AND matches.id IN (select card_id from user_cards)
      -- where cards.onyx_available IS TRUE
      union all
      select
        combos.card_id,
        cards.name as card_name,
        4 as card_rarity,
        matches.id as match_id,
        matches.name as match_name,
        4 as match_rarity,
        finals.name as final_name,
        4 as final_rarity,
        (case when finals.rarity = 0 then 9
                when finals.rarity = 1 then 7
                when finals.rarity = 2 then 5 else 3 end) as modifier,
          finals.base_offense,
          finals.base_defense,
          4 as rarity_multiplier
      from combos
      join cards on combos.card_id = cards.id
      join cards matches on combos.match_id = matches.id
      join cards finals on combos.final_id = finals.id
      join user_cards on user_cards.card_id = combos.card_id
      where cards.id IN (select card_id from user_cards where onyx IS TRUE) AND matches.id IN (select card_id from user_cards where onyx IS TRUE)
      -- where cards.onyx_available IS TRUE and matches.onyx_available IS TRUE
      and cards.id <> matches.id
      ) as x
      -- where (x.card_id NOT IN (select card_id from deck_cards) OR x.match_id NOT IN (select card_id from deck_cards))
      where x.card_id NOT IN (37,71,422,662,931,973,1082,1153,1325,1333) and x.match_id NOT IN (37,71,422,662,931,973,1082,1153,1325,1333)
      -- where card_id = 61
      order by power desc, final_offense desc, final_name, card_name, match_name
          SQL
          )
    end
end
