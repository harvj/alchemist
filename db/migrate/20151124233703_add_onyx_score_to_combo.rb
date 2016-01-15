class AddOnyxScoreToCombo < ActiveRecord::Migration
  def change
    add_column :combos, :onyx_score, :float
  end
end
