class Card < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :combos

  scope :combo, -> { where(classification: 'combo') }

  def display_name
    name.titleize
  end

  def final?
    classification == 'final'
  end

  def multiplier
    case color
    when 'diamond'
      4
    when 'gold'
      3
    when 'silver'
      2
    when 'bronze'
      1
    end
  end

end
