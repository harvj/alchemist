class AddUserCombos < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.timestamps
    end

    create_table :user_combos do |t|
      t.references :user, index: true
      t.references :combo, index: true
      t.datetime :researched
      t.timestamps
    end
  end
end
