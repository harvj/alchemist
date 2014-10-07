class InitialSchema < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string  :name
      t.string  :color
      t.integer :base_offense
      t.integer :base_defense
      t.timestamps
    end

    create_table :combos do |t|
      t.integer :card_id
      t.integer :match_id
      t.integer :final_id
      t.timestamps
    end

    create_table :decks do |t|
      t.timestamps
    end

    create_table :deck_cards do |t|
      t.references :deck
      t.references :card
    end
  end
end
