class AddUserSortPrefs < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deck_sort_pref, :string
    add_column :users, :combo_sort_pref, :string
    add_column :users, :side_sort_pref, :string
  end
end
