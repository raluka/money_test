require 'spec_helper'

describe Money do

  describe '#initialize' do
    it 'should be initialized with amount and currency' do
      fifty_eur = Money.new(50, 'EUR')
      expect(fifty_eur.amount).to eq(50)
      expect(fifty_eur.base_currency).to eq('EUR')
    end
  end

  describe '#inspect' do
    it 'should return amount and currency for Money as a string' do
      fifty_eur = Money.new(50, 'EUR')
      expect(fifty_eur.inspect).to match('50.00 EUR')
    end
  end

  context 'money_conversion' do
    before :each do
      @ten_eur = Money.new(10, 'EUR')
    end

    describe '#conversion_rates' do
      it 'should return conversion rates for specified currency from bank' do
        Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
        expect(Money.new(0, 'USD').bank.exchange_rates.keys).to include('EUR')
        expect(Money.new(50, 'Bitcoin').bank.exchange_rates['EUR']).to eq({'USD' => 1.11, 'Bitcoin' => 0.0047})
      end
    end

    describe '#convert_to' do
      it 'should convert one currency into another currency' do
        ten_eur_to_usd = @ten_eur.convert_to('USD')
        expect(ten_eur_to_usd).to eq(Money.new(11.1, 'USD'))
      end

      it 'should raise error if exchange rate not available' do
        expect{ @ten_eur.convert_to('GBP') }.to raise_error(UndefinedCurrency)
      end
    end
  end

  context 'money_operations' do
    before :each do
      Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
      Money.conversion_rates('USD', {'EUR' => 0.901, 'Bitcoin' => 0.0042})
      Money.conversion_rates('Bitcoin', {'EUR' => 212.766, 'USD' => 236.1702})
      @fifty_eur = Money.new(50, 'EUR')
      @five_eur = Money.new(5, 'EUR')
      @twenty_dollars = Money.new(20, 'USD')
      @ten_dollars = Money.new(10, 'USD')
    end

    context 'comparisons' do

      describe '#==' do
        it 'should be true for same amount of currency' do
          expect(@fifty_eur == Money.new(50, 'EUR')).to be_truthy
        end

        it 'should be false for same amount of different currencies' do
          expect(@fifty_eur == Money.new(50, 'USD')).to be_falsey
        end

        it 'should be false for different amounts of same currency' do
          expect(@fifty_eur == Money.new(20, 'EUR')).to be_falsey
        end

        it 'should be false for different amounts of Money and currency' do
          expect(@fifty_eur == @twenty_dollars).to be_falsey
        end

        it 'should be true for same quantity' do
          expect(@twenty_dollars == Money.new(18.02, 'EUR')).to be_truthy
        end

        it 'should be true for zero amounts of same or different currencies' do
          expect(Money.new(0, 'EUR') == Money.new(0, 'Bitcoin')).to be_truthy
        end

        it 'should return false for objects different than money' do
          expect(@five_eur == 5).to be_falsey
        end
      end

      describe '#<' do
        it 'should return proper comparison for same currency' do
          expect(@fifty_eur < Money.new(60, 'EUR')).to be_truthy
          expect(@fifty_eur < Money.new(5, 'EUR')).to be_falsey
        end

        it 'should return proper comparison for different currencies' do
          expect(@five_eur < @twenty_dollars).to be_truthy
        end

        it 'should raise error of compared objects are not money' do
          expect{ @five_eur < 1 }.to raise_error(TypeError)
        end
      end

      describe '#>' do
        it 'should return proper comparison for same currency' do
          expect(@fifty_eur > Money.new(60, 'EUR')).to be_falsey
          expect(@fifty_eur > Money.new(5, 'EUR')).to be_truthy
        end

        it 'should return proper comparison for different currencies' do
          expect(@ten_dollars > @five_eur).to be_truthy
        end

        it 'should raise error of compared objects are not money' do
          expect{ @five_eur > 1 }.to raise_error(TypeError)
        end
      end
    end

    context 'arithmetic operations' do

      describe '#*' do
        it 'should multiply given amount by factor' do
          expect(@five_eur * 10).to eq(@fifty_eur)
        end

        it 'should raise error if factor is not a number' do
          expect{ @five_eur * 'EUR' }.to raise_error(TypeError)
        end
      end

      describe '#/' do
        it 'should divide an amount of Money by a factor' do
          expect(@fifty_eur / 10).to eq(@five_eur)
        end

        it 'should raise error if factor is not a number' do
          expect { @fifty_eur / 'EUR' }.to raise_error(TypeError)
        end

        it 'should raise error if factor is zero' do
          expect{ @fifty_eur / 0 }.to raise_exception(InfiniteException)
        end
      end

      describe '#+' do
        it 'should add two amounts of same currency' do
          expect(@five_eur + @fifty_eur).to eq(Money.new(55, 'EUR'))
        end

        it 'should add different currencies with known exchange rate' do
          expect(@five_eur + @ten_dollars).to eq(Money.new(14.01, 'EUR'))
        end

        it 'should raise error if attempt to add different currencies with unknown exchange rate' do
          expect{ @five_eur + Money.new(5, 'GBP') }.to raise_error(UndefinedCurrency)
        end

        it 'should raise error if attempt to add other than Money' do
          expect { @five_eur + 5 }.to raise_error(TypeError)
        end
      end

      describe '#-' do
        it 'should subtract two amounts of same currency' do
          expect(@five_eur - @fifty_eur).to eq(Money.new(-45, 'EUR'))
          expect(@fifty_eur - @five_eur).to eq(Money.new(45, 'EUR'))
        end

        it 'should subtract different currencies with known exchange rate' do
          expect(@fifty_eur - @twenty_dollars).to eq(Money.new(31.98, 'EUR'))
        end

        it 'should raise error if attempt to subtract different currencies with unknown exchange rate' do
          expect{@fifty_eur - Money.new(5, 'GBP')}.to raise_error(UndefinedCurrency)
        end

        it 'should raise error if attempt to subtract other than Money' do
          expect { @five_eur - 5 }.to raise_error(TypeError)
        end
      end
    end
  end
end
