class AddOnyxAvailabilityToCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :score, :float
    add_column :cards, :onyx_available, :boolean, default: false
    add_column :cards, :origin, :integer, default: 0
    remove_column :combos, :score, :float
    remove_column :combos, :onyx_score, :float

    add_index :cards, :origin
  end
end
