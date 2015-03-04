class AddScoreToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :score, :float
  end
end
