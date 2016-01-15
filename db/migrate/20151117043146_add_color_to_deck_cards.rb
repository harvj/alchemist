class AddColorToDeckCards < ActiveRecord::Migration
  def change
    add_column :deck_cards, :color, :string
  end
end
