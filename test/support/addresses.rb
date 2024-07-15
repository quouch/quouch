# frozen_string_literal: true

ADDRESSES = [
  {street: "123 Main St", city: "New York", country: "USA", zipcode: "10001"},
  {street: "456 Market St", city: "San Francisco", country: "USA", zipcode: "94105"},
  {street: "10 Downing St", city: "London", country: "UK", zipcode: "SW1A 2AA"},
  {street: "Unter den Linden 77", city: "Berlin", country: "Germany", zipcode: "10117"},
  {street: "Piazza del Colosseo 1", city: "Rome", country: "Italy", zipcode: "00184"},
  {street: "Plaza de Cibeles 1", city: "Madrid", country: "Spain", zipcode: "28014"},
  {street: "Rue de la Loi 200", city: "Brussels", country: "Belgium", zipcode: "1000"},
  {street: "Av. Paulista, 1578", city: "São Paulo", country: "Brazil", zipcode: "01310-200"},
  {street: "Calle 10 # 5-51", city: "Bogotá", country: "Colombia", zipcode: "111711"},
  {street: "Av. 9 de Julio 1925", city: "Buenos Aires", country: "Argentina", zipcode: "C1073ABA"},
  {street: "Rue Dr. Robert Delmas", city: "Port-au-Prince", country: "Haiti", zipcode: "HT6110"},
  {street: "Avenue Hassan II", city: "Rabat", country: "Morocco", zipcode: "10030"},
  {street: "Rue de Commerce", city: "Dakar", country: "Senegal", zipcode: "18524"},
  {street: "Jl. Medan Merdeka Selatan No.13", city: "Jakarta", country: "Indonesia", zipcode: "10110"},
  {street: "2 Chome-3-1 Nishishinjuku", city: "Tokyo", country: "Japan", zipcode: "163-8001"},
  {street: "350 Euston Rd", city: "Mumbai", country: "India", zipcode: "400098"},
  {street: "Jl. Jend. Sudirman Kav.52-53", city: "Jakarta", country: "Indonesia", zipcode: "12190"},
  {street: "1 Austin Rd W", city: "Hong Kong", country: "Hong Kong", zipcode: "HKG"},
  {street: "111 Bourke St", city: "Melbourne", country: "Australia", zipcode: "3000"}
].freeze

# Parse the addresses to verify their existence in google maps
# 123 Main St, New York, USA, 10001
# 456 Market St, San Francisco, USA, 94105
# 10 Downing St, London, UK, SW1A 2AA
#   Unter den Linden 77, Berlin, Germany, 10117
#  Piazza del Colosseo 1, Rome, Italy, 00184
# Plaza de Cibeles 1, Madrid, Spain, 28014
# Rue de la Loi 200, Brussels, Belgium, 1000
# Av. Paulista, 1578, São Paulo, Brazil, 01310-200
# Calle 10 # 5-51, Bogotá, Colombia, 111711
# Av. 9 de Julio 1925, Buenos Aires, Argentina, C1072
# Rue Dr. Robert Delmas, Port-au-Prince, Haiti, HT6110
# Avenue Hassan II, Rabat, Morocco, 10030
# Rue de Commerce, Dakar, Senegal, 18524
# Jl. Medan Merdeka Selatan No.13, Jakarta, Indonesia, 10110
# 2 Chome-3-1 Nishishinjuku, Tokyo, Japan, 163-8001
# 350 Euston Rd, Mumbai, India, 400098
# Jl. Jend. Sudirman Kav.52-53, Jakarta, Indonesia, 12190
# 1 Austin Rd W, Hong Kong, Hong Kong, HKG
# 111 Bourke St, Melbourne, Australia, 3000
#
