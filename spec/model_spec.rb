require 'spec_helper'

describe Xmoney::Model do
  class Money
    include Xmoney::Model
  end

  describe 'instance' do
    context 'when the currency in unknown' do
      specify do
        expect { Money.new(50, 'EUR') }.to raise_error Xmoney::UNKNOWN_CURRENCY
      end
    end

    context 'given a proper configuration' do
      let(:usd) { Money.new(50.01, 'USD') }
      let(:eur) { Money.new(10.12, 'EUR') }
      before do
        Xmoney.configure do
          add_currency 'EUR', { 'USD' => 0.80 }
          add_currency 'USD', { 'EUR' => 1.20 }
        end
      end

      specify do
        expect(usd.amount).to eq(50.01)
        expect(usd.currency).to eq('USD')
        expect(usd.to_s).to eq('50.01 USD')
        expect(eur.amount).to eq(10.12)
        expect(eur.currency).to eq('EUR')
        expect(eur.to_s).to eq('10.12 EUR')
      end
    end
  end

  describe '#convert_to' do
    before do
      Xmoney.configure do
        add_currency 'EUR', { 'USD' => 0.80 }
        add_currency 'USD', { 'EUR' => 1.20 }
      end
    end

    specify do
      expect { Money.new(10, 'EUR').convert_to('BITCOIN') }.to raise_error Xmoney::UNKNOWN_CURRENCY
    end
    specify do
       expect(Money.new(10, 'EUR').convert_to('USD')).to eq('8 USD')
       expect(Money.new(16, 'USD').convert_to('EUR')).to eq('19.2 EUR')
    end
  end
end
