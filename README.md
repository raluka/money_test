# Money Test

Money Converter
Perform currency conversion and arithmetic with different currencies.
Please note that this gem is created with single purpose of improving Ruby skills, so it is very far from perfect.

## Installation


Install it as:

    $ gem build money.gemspec
    $ gem install ./money_test-0.0.0.gem
    
## Features

- Provides a `Money` class which encapsulates all information about an certain amount of money 
  (such as its value and its currency), and performs money operations.
- Provides a `Bank` class which keeps exchange rates and perform currency exchanges.


## Usage



```ruby
require 'money'

# Configure the currency rates with respect to a base currency (here EUR):
# This can and should be set at the beginning of project.

Money.conversion_rates('EUR', { 'USD' => 1.11, 'Bitcoin' => 0.0047 })

# Instantiate money objects:

fifty_eur = Money.new(50, 'EUR')

# Get amount and currency:

fifty_eur.amount   # => 50.0
fifty_eur.currency # => "EUR"
fifty_eur.inspect  # => "50.00 EUR"

# Convert to a different currency (returns a Money instance):

fifty_eur.convert_to('USD') # => 55.50 USD

# Perform operations in different currencies:

twenty_dollars = Money.new(20, 'USD')

# Arithmetics:

fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparisons (also in different currencies):

twenty_dollars == Money.new(20, 'USD') # => true
twenty_dollars == Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur             # => true
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
