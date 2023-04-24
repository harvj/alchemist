class AddOnyxColumnToUserCards < ActiveRecord::Migration[7.0]
  def change
    add_column :user_cards, :onyx, :boolean, default: false
  end
end
