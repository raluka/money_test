require 'singleton'

class Bank
  include Singleton
  attr_reader :exchange_rates

  def initialize
    @exchange_rates = {}
  end


  def exchange(from_currency, to_currency)
    if excange_exists?(from_currency, to_currency)
      @exchange_rates[from_currency][to_currency]
    else
      raise UndefinedCurrency, "Define exchange rate for #{from_currency} to #{to_currency}"
    end
  end

  def excange_exists?(from_currency, to_currency)
    @exchange_rates.has_key?(from_currency) && @exchange_rates[from_currency].has_key?(to_currency)
  end

  def add_rate(base_currency, currency_to, rate)
    if @exchange_rates.has_key?(base_currency)
      update_rate(base_currency, currency_to, rate)
    else
      create_rate(base_currency, currency_to, rate)
    end

  end

  private

  def update_rate(base_currency, currency_to, rate)
    @exchange_rates[base_currency][currency_to] = rate
  end

  def create_rate(base_currency, currency_to, rate)
    @exchange_rates.store(base_currency, {currency_to => rate})
  end
end
