require 'spec_helper'

describe Bank do

  before :each do
    @bank = Bank.instance
  end

  it 'should return only one bank' do
    bank_2 = Bank.instance
    expect(bank_2).to be(@bank)
  end

  it 'should add new exchange rate for base currency' do
    @bank.add_rate('EUR', 'USD', 2)
    expect(@bank.exchange_rates).to eq({'EUR' => {'USD' => 2}})
    @bank.add_rate('EUR', 'Bitcoin', 0.5)
    expect(@bank.exchange_rates).to eq({'EUR' => {'USD' => 2, 'Bitcoin' => 0.5}})
  end

  it 'should change Money into other currency' do
    @bank.add_rate('EUR', 'USD', 2)
    result = @bank.exchange('EUR', 'USD')
    expect(result).to eq(2)
  end

  it 'should raise error if exchange rate not known' do
    expect{@bank.exchange('USD', 'EUR')}.to raise_error(UndefinedCurrency)
  end
end
