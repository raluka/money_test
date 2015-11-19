Dir["lib/**/*.rb"].sort.each { |file| require(File.dirname(__FILE__) + "/"+ file) }

class Monney
  include Comparable
  attr_reader :amount, :base_currency, :bank

  def initialize(amount, currency)
    @amount = amount.to_f.round(2)
    @base_currency = currency
    @bank = Bank.instance
  end

  def inspect
    "#{"%0.02f" % @amount} #{@base_currency}"
  end

  def <=>(other)
    raise StandardError unless other.is_a?(Monney)
    if self.base_currency != other.base_currency
      other = other.convert_to(self.base_currency)
    end
    self.amount <=> other.amount
  end

  def *(factor)
    if factor.is_a?(Numeric)
      Monney.new(amount * factor, base_currency)
    else
      raise ArgumentError
    end
  end

  def /(factor)
    if factor.is_a? Numeric
      if factor == 0
        raise InfiniteException
      else
        Monney.new(amount / factor, base_currency)
      end
    else
      raise TypeError
    end
  end

  def +(other)
    if self.base_currency == other.base_currency
      Monney.new(amount + other.amount, base_currency)
    else
      Monney.new(amount + other.convert_to(self.base_currency).amount, base_currency)
    end
  end

  def -(other)
    if self.base_currency == other.base_currency
      Monney.new(amount - other.amount, base_currency)
    else
      Monney.new(amount - other.convert_to(self.base_currency).amount, base_currency)
    end
  end

  def self.conversion_rates(base_currency, options = {})
    options.each do |key, value|
      Bank.instance.add_rate(base_currency, key, value)
    end
  end

  def convert_to(to_currency)
    Monney.new(self.amount * exchange_rate(to_currency), to_currency)
  end

  private

  def exchange_rate(to_currency)
    self.bank.exchange(self.base_currency, to_currency)
  end

end

