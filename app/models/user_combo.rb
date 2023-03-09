class UserCombo < ApplicationRecord
  belongs_to :user
  belongs_to :combo

  validates :combo_id, uniqueness: { scope: :user_id }

  scope :researched, -> { where('researched IS NOT NULL') }
end
