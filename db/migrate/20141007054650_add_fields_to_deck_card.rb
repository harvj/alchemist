class AddFieldsToDeckCard < ActiveRecord::Migration
  def change
    add_column :deck_cards, :level, :integer
    add_column :deck_cards, :fused, :boolean
  end
end
