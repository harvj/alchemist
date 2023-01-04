class Change < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :color, :string
    add_column :cards, :rarity, :integer
    add_index :cards, :rarity

    remove_column :cards, :classification, :string
    add_column :cards, :form, :integer
    add_index :cards, :form

    add_column :cards, :fusion, :integer
    add_index :cards, :fusion

    add_index :combos, :partner_id

    remove_column :deck_cards, :color, :string
    add_column :deck_cards, :rarity, :integer
    add_index :deck_cards, :rarity

    add_index :deck_cards, :deck_id
    add_index :deck_cards, :card_id
    add_index :deck_cards, :level

    add_column :decks, :name, :string
  end
end
