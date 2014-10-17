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

  puts "No card with name #{row[0]}" if card_id.nil?
  puts "No match with name #{row[1]}" if match_id.nil?
  puts "No final with name #{row[2]}" if final_id.nil?

  Combo.create!(card_id: card_id, match_id: match_id, final_id: final_id)
end

deck = Deck.create!

CSV.foreach('db/seeds/deck_cards.csv') do |row|
  break if row[0] == 'stop'
  row[0].to_i.times do
    card = Card.find_by!(name: row[1])
    deck.cards << DeckCard.create!(card_id: card.id, level: row[2], fused: row[3])
  end
end

Rake::Task['data:card_scores'].invoke
