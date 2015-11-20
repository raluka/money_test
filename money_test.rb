require 'money'

Money.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 })
Money.conversion_rates('USD', { 'EUR' => 0.9009 })
# Instantiate money objects:

fifty_eur = Money.new(50, 'EUR')

# Get amount and currency:

p fifty_eur.amount   # => 50.0
p fifty_eur.base_currency # => "EUR"
p fifty_eur.inspect  # => "50.00 EUR"

# Convert to a different currency (returns a Money instance):

p fifty_eur.convert_to('USD') # => 55.50 USD

# Perform operations in different currencies:

p twenty_dollars = Money.new(20, 'USD')

# Arithmetics:
p fifty_eur
p twenty_dollars
p twenty_dollars.convert_to('EUR')
p fifty_eur + twenty_dollars # => 68.02 EUR
p fifty_eur - twenty_dollars # => 31.98 EUR
p fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparisons (also in different currencies):

p twenty_dollars == Money.new(20, 'USD') # => true
p twenty_dollars == Money.new(30, 'USD') # => false

p fifty_eur_in_usd = fifty_eur.convert_to('USD')
p fifty_eur_in_usd == fifty_eur          # => true

p twenty_dollars > Money.new(5, 'USD')   # => true
p twenty_dollars < fifty_eur             # => true
