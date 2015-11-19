require 'singleton'

# provides ability to exchange one currency with another
class Bank
  include Singleton
  attr_reader :exchange_rates

  # Returns the singleton instance of Bank
  def initialize
    @exchange_rates = {}
  end

  # Allows to add new exchange rate
  def add_rate(base_currency, currency_to, rate)
    if @exchange_rates.has_key?(base_currency)
      update_rate(base_currency, currency_to, rate)
    else
      create_rate(base_currency, currency_to, rate)
    end
  end

  # Does the exchange from one currency to another
  def exchange(from_currency, to_currency)
    if exchange_exists?(from_currency, to_currency)
      @exchange_rates[from_currency][to_currency]
    else
      raise UndefinedCurrency, "Define exchange rate for #{from_currency} to #{to_currency}"
    end
  end

  private
  # Creates exchange rate for a new currency
  def create_rate(base_currency, currency_to, rate)
    @exchange_rates.store(base_currency, {currency_to => rate})
  end

  # Updates exchange rate for a currency
  def update_rate(base_currency, currency_to, rate)
    @exchange_rates[base_currency][currency_to] = rate
  end

  # Checks if it is an exchange rate
  def exchange_exists?(from_currency, to_currency)
    @exchange_rates.has_key?(from_currency) && @exchange_rates[from_currency].has_key?(to_currency)
  end
end
