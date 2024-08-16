# frozen_string_literal: true

ADDRESSES = [
  { street: '123 Main St', city: 'New York', country: 'United States', zipcode: '10001', country_code: 'US' },
  { street: '456 Market St', city: 'San Francisco', country: 'United States', zipcode: '94105', country_code: 'US' },
  { street: '10 Downing St', city: 'London', country: 'United Kingdom', zipcode: 'SW1A 2AA', country_code: 'GB' },
  { street: 'Unter den Linden 77', city: 'Berlin', country: 'Germany', zipcode: '10117', country_code: 'DE' },
  { street: 'Piazza del Colosseo 1', city: 'Rome', country: 'Italy', zipcode: '00184', country_code: 'IT' },
  { street: 'Plaza de Cibeles 1', city: 'Madrid', country: 'Spain', zipcode: '28014', country_code: 'ES' },
  { street: 'Rue de la Loi 200', city: 'Brussels', country: 'Belgium', zipcode: '1000', country_code: 'BE' },
  { street: 'Av. Paulista, 1578', city: 'São Paulo', country: 'Brazil', zipcode: '01310-200', country_code: 'BR' },
  { street: 'Calle 10 # 5-51', city: 'Bogotá', country: 'Colombia', zipcode: '111711', country_code: 'CO' },
  { street: 'Av. 9 de Julio 1925', city: 'Buenos Aires', country: 'Argentina', zipcode: 'C1073ABA',
    country_code: 'AR' },
  { street: 'Rue Dr. Robert Delmas', city: 'Port-au-Prince', country: 'Haiti', zipcode: 'HT6110', country_code: 'HT' },
  { street: 'Avenue Hassan II', city: 'Rabat', country: 'Morocco', zipcode: '10030', country_code: 'MA' },
  { street: 'Rue de Commerce', city: 'Dakar', country: 'Senegal', zipcode: '18524', country_code: 'SN' },
  { street: 'Jl. Medan Merdeka Selatan No.13', city: 'Jakarta', country: 'Indonesia', zipcode: '10110',
    country_code: 'ID' },
  { street: '2 Chome-3-1 Nishishinjuku', city: 'Tokyo', country: 'Japan', zipcode: '163-8001', country_code: 'JP' },
  { street: '350 Euston Rd', city: 'Mumbai', country: 'India', zipcode: '400098', country_code: 'IN' },
  { street: 'Jl. Jend. Sudirman Kav.52-53', city: 'Jakarta', country: 'Indonesia', zipcode: '12190',
    country_code: 'ID' },
  { street: '1 Austin Rd W', city: 'Hong Kong', country: 'Hong Kong', zipcode: 'HKG', country_code: 'HK' },
  { street: '111 Bourke St', city: 'Melbourne', country: 'Australia', zipcode: '3000', country_code: 'AU' }
].freeze

# Parse the addresses to verify their existence in google maps
# 123 Main St, New York, United States, 10001
# 456 Market St, San Francisco, United States, 94105
# 10 Downing St, London, United Kingdom, SW1A 2AA
# Unter den Linden 77, Berlin, Germany, 10117
# Piazza del Colosseo 1, Rome, Italy, 00184
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
