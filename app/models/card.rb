class Card < ApplicationRecord
  validates :name, :base_offense, :base_defense, :rarity, :form, :fusion, presence: true
  validates :name, uniqueness: { scope: :rarity }

  enum rarity: RARITIES
  enum form: FORMS
  enum fusion: FUSIONS
  enum origin: ORIGINS

  has_many :combos
  has_many :deck_cards

  scope :combo, -> { where(form: 'combo') }
  scope :combof2p, -> { where(form: 'combo').where('origin < ?', 100)}

  def cards_no_combo_with
    Card.find_by_sql(<<~SQL
      select * from cards
      where form = 0
      and id NOT IN (select match_id from combos where card_id = #{id})
    SQL
    )
  end

  def knowable_combo_names
    Card.find_by_sql(<<~SQL
      select cards.name from combos
      join cards on combos.match_id = cards.id
      where card_id = #{id}
      and match_id IN (select card_id from user_cards)
      and match_id NOT IN (
        select cards.id from user_combos
        join combos on user_combos.combo_id = combos.id AND user_combos.researched IS NOT NULL
        join cards on cards.id = combos.match_id
        and combos.card_id = #{id}
      )
    SQL
    )
  end

  def combos(params={})
    id_table = combo? ? 'cards' : 'finals'
    Combo.find_by_sql(<<~SQL
      SELECT
        y.*,
        (select #{deck_card_sql(params[:deck_id])}) as deck_card_count,
        (select #{deck_match_sql(params[:deck_id])}) as deck_match_count,
        onyx_offense + onyx_defense as onyx_power,
        diamond_offense + diamond_defense as diamond_power,
        offense + defense as power,
        base_offense + base_defense as base_power
      FROM (SELECT x.*,
        base_multiplier * level_multiplier + base_offense as offense,
        base_multiplier * level_multiplier + base_defense as defense,
        (case when card_onyx_avail OR match_onyx_avail then diamond_mod + base_offense + 20 else base_multiplier * level_multiplier + base_offense end) as diamond_offense,
        (case when card_onyx_avail OR match_onyx_avail then diamond_mod + base_defense + 20 else base_multiplier * level_multiplier + base_defense end) as diamond_defense,
        onyx_mod + base_offense + 20 as onyx_offense,
        onyx_mod + base_defense + 20 as onyx_defense
      FROM (SELECT
          cards.id as card_id,
          cards.name as card_name,
          cards.onyx_available as card_onyx_avail,
          matches.id as match_id,
          matches.name as match_name,
          matches.onyx_available as match_onyx_avail,
          finals.id as final_id,
          finals.name as final_name,
          finals.base_offense,
          finals.base_defense,
          cards.rarity as card_rarity,
          matches.rarity as match_rarity,
          finals.rarity as final_rarity,
          finals.fusion,
          combos.id as combo_id,
          combos.partner_id as partner_id,
          user_combos.researched,
          greatest(cards.rarity, matches.rarity) as high_rarity,
          greatest(cards.rarity, matches.rarity) + 1 as base_multiplier,
          (case when finals.rarity = 0 then 9
                when finals.rarity = 1 then 7
                when finals.rarity = 2 then 5 else 3 end
          ) as onyx_mod,
          (case when finals.rarity = 0 then 7
                when finals.rarity = 1 then 5
                when finals.rarity = 2 then 3 else 0 end
          ) as diamond_mod,
          (case when finals.rarity IN (0,1) then 4 else 5 end) as level_multiplier
        FROM cards
        JOIN combos ON combos.card_id = cards.id
        JOIN cards matches ON combos.match_id = matches.id
        JOIN cards finals ON combos.final_id = finals.id
        LEFT OUTER JOIN user_combos ON combos.id = user_combos.combo_id and user_combos.user_id = #{params[:user_id]}
        WHERE cards.form = 0
        AND #{id_table}.id = #{id}
        #{"AND combos.card_id <= combos.match_id" if final?}
        AND combos.card_id IN (select card_id from user_cards where user_cards.user_id = #{params[:user_id]})
        AND combos.match_id IN (select card_id from user_cards where user_cards.user_id = #{params[:user_id]})
      ) as x
     ) as y
      #{sort_sql(params[:sort])}
    SQL
    )
  end

  def display_name
    name.titleize
  end

  private

  def deck_card_sql(deck_id)
    return 'NULL' if deck_id.nil?
    <<~SQL
      count(id) from deck_cards where card_id = y.card_id and deck_cards.deck_id = #{deck_id}
    SQL
  end

  def deck_match_sql(deck_id)
    return 'NULL' if deck_id.nil?
    <<~SQL
      count(id) from deck_cards where card_id = y.match_id and deck_cards.deck_id = #{deck_id}
    SQL
  end

  def sort_sql(sort)
    if sort == 'matchname'
      'ORDER BY match_name ASC'
    elsif sort == 'offense'
      'ORDER BY diamond_offense DESC, power DESC, final_name ASC, card_name ASC, match_name ASC'
    elsif sort == 'rarity'
      'ORDER BY'
    else
      'ORDER BY power DESC, diamond_offense DESC, final_name ASC, card_name ASC, match_name ASC'
    end
  end
end
