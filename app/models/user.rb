class User < ApplicationRecord
  validates :username, presence: true

  has_many :user_cards
  has_many :user_combos

  def unknown_combo_counts
    UserCombo.find_by_sql(<<~SQL
      select
        cards.name as card_name,
        count(*)
      from combos
      join user_cards card_uc on card_uc.card_id = combos.card_id and card_uc.user_id = #{id}
      join user_cards match_uc on match_uc.card_id = combos.match_id and match_uc.user_id = #{id}
      join cards on cards.id = combos.card_id
      where combos.id NOT IN (select combo_id from user_combos where researched IS NOT NULL)
      group by cards.name
      order by count desc, card_name ASC
    SQL
    )
  end
end
