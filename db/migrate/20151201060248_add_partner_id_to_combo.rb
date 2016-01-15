class AddPartnerIdToCombo < ActiveRecord::Migration
  def change
    add_column :combos, :partner_id, :integer
  end
end
