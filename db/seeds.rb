# run rake db:reset

require 'csv'

user = User.create(username: 'kalep')

CSV.foreach('db/seeds/cards.csv') do |row|
  puts "Creating card #{row[0]}"
  Card.create!(
    name: row[0],
    rarity: Card::RARITIES[row[1].to_sym],
    base_offense: row[2],
    base_defense: row[3],
    form: Card::FORMS[row[4].to_sym],
    fusion: Card::FUSIONS[row[5].tr(' ','_').to_sym],
    origin: Card::ORIGINS[row[6].tr(' ','_').to_sym],
    onyx_available: row[7]
  )
end

CSV.foreach('db/seeds/combos.csv') do |row|
  card_id = Card.find_by(name: row[0])&.id
  match_id = Card.find_by(name: row[1])&.id
  final_id = Card.find_by(name: row[2])&.id

  puts "No card with name #{row[0]}" if card_id.nil?
  puts "No match with name #{row[1]}" if match_id.nil?
  puts "No final with name #{row[2]}" if final_id.nil?

  exists = Combo.find_by(card_id: card_id, match_id: match_id)
  puts "Creating combo #{row[0]}, #{row[1]}: #{row[2]}"
  Combo.create!(card_id: card_id, match_id: match_id, final_id: final_id) unless exists
end

Deck.create!(name: 'arena')
# Deck.create!(name: 'starter')

CSV.foreach('db/seeds/deck_cards.csv') do |row|
  puts "Creating deck card #{row[1]}"
  card_id = Card.find_by(name: row[1])&.id
  fused = row[2] == 'F'
  level = fused ? 5 : row[2]
  rarity = row[3]
  DeckCard.create!(deck_id: row[0], card_id: card_id, level: level, fused: fused, rarity: rarity)
end

CSV.foreach('db/seeds/user_cards.csv') do |row|
  puts "Creating user card #{row[0]}"
  card_id = Card.find_by(name: row[0])&.id
  UserCard.create!(user_id: user.id, card_id: card_id)
end

# Rake::Task['data:combo_scores'].invoke
# Rake::Task['data:card_scores'].invoke
