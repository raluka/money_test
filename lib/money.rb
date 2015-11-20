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
  attr_reader :amount, :base_currency, :bank

# Creates a new instance of Money with value, currency, and associated Bank. It returns a Money object.
  def initialize(amount, currency)
    @amount = amount.to_f.round(2)
    @base_currency = currency
    @bank = Bank.instance
  end

# Returns a string containing a human-readable representation of obj.
  def inspect
    "#{"%0.02f" % @amount} #{@base_currency}"
  end

# Compares equality between two amounts of money.
  def <=>(other)
    raise TypeError unless other.is_a?(Money)
    if self.base_currency != other.base_currency
      other = other.convert_to(self.base_currency)
    end
    self.amount <=> other.amount
  end

# Multiplies an amount of money by a factor
  def *(factor)
    if factor.is_a?(Numeric)
      Money.new(amount * factor, base_currency)
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
        Money.new(amount / factor, base_currency)
      end
    else
      raise TypeError
    end
  end

# Add two amounts of money, with currency conversion if needed
  def +(other)
    raise TypeError unless other.is_a?(Money)
    if self.base_currency == other.base_currency
      Money.new(amount + other.amount, base_currency)
    else
      Money.new(amount + other.convert_to(self.base_currency).amount, base_currency)
    end
  end

# Subtract two amounts of money, with currency conversion if needed
  def -(other)
    raise TypeError unless other.is_a?(Money)
    if self.base_currency == other.base_currency
      Money.new(amount - other.amount, base_currency)
    else
      Money.new(amount - other.convert_to(self.base_currency).amount, base_currency)
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
    self.bank.exchange(self.base_currency, to_currency)
  end
end
