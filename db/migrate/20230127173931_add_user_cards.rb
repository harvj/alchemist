class AddUserCards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cards do |t|
      t.references :user, index: true
      t.references :card, index: true
      t.timestamps
    end
  end
end
