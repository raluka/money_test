require 'money/version'
require 'money/bank'
require 'money/infinite_exception'
require 'money/undefined_currency'

# An instance of Money represent an amount of a certain currency
class Money
  include Comparable

#  attr_reader :amount returns defined quantity of Money
#  attr_reader :currency returns defined currency for Money
#  attr_reader :bank returns Bank.instance which performs currency exchanges
  attr_reader :amount, :currency, :bank

# Creates a new instance of Money with value, currency, and associated Bank. It returns a Money object.
  def initialize(amount, currency)
    @amount = amount.to_f.round(2)
    @currency = currency
    @bank = Bank.instance
  end

# Returns a string containing a human-readable representation of obj.
  def inspect
    "#{"%0.02f" % @amount} #{@currency}"
  end

# Compares equality between two amounts of money.
  def <=>(other)
    raise TypeError unless other.is_a?(Money)
    if self.currency != other.currency
      other = other.convert_to(self.currency)
    end
    self.amount <=> other.amount
  end

# Multiplies an amount of money by a factor
  def *(factor)
    if factor.is_a?(Numeric)
      Money.new(amount * factor, currency)
    else
      raise TypeError
    end
  end

# Divides an amount of money by a factor
  def /(factor)
    if factor.is_a?(Numeric)
      if factor == 0
        raise InfiniteException
      else
        Money.new(amount / factor, currency)
      end
    else
      raise TypeError
    end
  end

# Add two amounts of money, with currency conversion if needed
  def +(other)
    raise TypeError unless other.is_a?(Money)
    if self.currency == other.currency
      Money.new(amount + other.amount, currency)
    else
      Money.new(amount + other.convert_to(self.currency).amount, currency)
    end
  end

# Subtract two amounts of money, with currency conversion if needed
  def -(other)
    raise TypeError unless other.is_a?(Money)
    if self.currency == other.currency
      Money.new(amount - other.amount, currency)
    else
      Money.new(amount - other.convert_to(self.currency).amount, currency)
    end
  end

# Converts one currency into another
  def convert_to(to_currency)
    Money.new(self.amount * exchange_rate(to_currency), to_currency)
  end

  # Class methods

# Add new exchange rates for currency
  def self.conversion_rates(currency, options = {})
    options.each do |key, value|
      Bank.instance.add_rate(currency, key, value)
    end
  end

  private

# Gets from Bank the exchange rate of currency
  def exchange_rate(to_currency)
    self.bank.exchange(self.currency, to_currency)
  end
end
