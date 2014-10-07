# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

CSV.foreach('db/seeds/cards.csv') do |row|
  Card.create!(name: row[0], color: row[1], base_offense: row[2], base_defense: row[3], classification: row[4])
end

CSV.foreach('db/seeds/combos.csv') do |row|
  card_id = Card.where(name: row[0]).pluck(:id).first
  match_id = Card.where(name: row[1]).pluck(:id).first
  final_id = Card.where(name: row[2]).pluck(:id).first
  Combo.create!(card_id: card_id, match_id: match_id, final_id: final_id)
end
