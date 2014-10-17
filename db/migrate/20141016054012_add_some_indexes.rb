class AddSomeIndexes < ActiveRecord::Migration
  def change
    add_index :combos, :card_id
    add_index :combos, :match_id
    add_index :combos, :final_id
  end
end
