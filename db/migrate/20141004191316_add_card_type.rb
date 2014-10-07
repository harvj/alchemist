class AddCardType < ActiveRecord::Migration
  def change
    add_column :cards, :classification, :string
  end
end
