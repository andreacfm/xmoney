require 'spec_helper'

describe Xmoney::Model do
  class Money
    include Xmoney::Model
  end

  def configure
    Xmoney.configure do
      add_currency 'EUR', { 'USD' => 0.80 }
      add_currency 'USD', { 'EUR' => 1.20 }
    end
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
      before { configure }

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
    before { configure }

    specify do
      expect { Money.new(10, 'EUR').convert_to('BITCOIN') }.to raise_error Xmoney::UNKNOWN_CURRENCY
    end
    specify do
      expect(Money.new(10, 'EUR').convert_to('USD').to_s).to eq('8 USD')
      expect(Money.new(16, 'USD').convert_to('EUR').to_s).to eq('19.2 EUR')
    end
  end

  describe '#+' do
    before { configure }
    let(:ten_eur) { Money.new(10, 'EUR') }
    let(:ten_usd) { Money.new(10, 'USD') }

    specify do
      expect("#{ten_eur + ten_usd}").to eq('22 EUR')
    end
    specify do
      expect("#{ten_usd + ten_eur}").to eq('18 USD')
    end
    specify do
      expect("#{ten_usd + ten_eur}").to eq('18 USD')
      expect("#{ten_eur + ten_usd}").to eq('31.6 EUR')
    end
  end

  describe '#-' do
    before { configure }
    let(:twenty_eur) { Money.new(20, 'EUR') }
    let(:ten_usd) { Money.new(10, 'USD') }

    specify do
      expect("#{twenty_eur - ten_usd}").to eq('8 EUR')
    end
    specify do
      expect("#{ten_usd - twenty_eur}").to eq('-6 USD')
    end
  end

  describe '#*' do
    before { configure }
    let(:ten_eur) { Money.new(10, 'EUR') }
    let(:ten_usd) { Money.new(10, 'USD') }

    specify do
      expect("#{ten_eur * ten_usd}").to eq('120 EUR')
    end
    specify do
      expect("#{ten_usd * ten_eur}").to eq('80 USD')
    end
  end

  describe '#/' do
    before { configure }
    let(:ten_eur) { Money.new(10, 'EUR') }
    let(:ten_usd) { Money.new(10, 'USD') }

    specify do
      expect("#{ten_eur / ten_usd}").to eq('0.83 EUR')
    end
    specify do
      expect("#{ten_usd / ten_eur}").to eq('1.25 USD')
    end
  end

  describe 'comparable' do
    before { configure }

    context '#==' do
      specify do
        expect(Money.new(10, 'EUR') == Money.new(10, 'USD')).to be_falsey
        expect(Money.new(10, 'USD') == Money.new(10, 'USD')).to be_truthy
        expect(Money.new(12, 'EUR') == Money.new(10, 'USD')).to be_truthy
        expect(Money.new(12.213, 'EUR') == Money.new(12.215, 'EUR')).to be_truthy
      end
    end

    context '#<=>' do
      specify do
        expect(Money.new(10, 'EUR') > Money.new(10, 'USD')).to be_falsey
        expect(Money.new(10, 'USD') > Money.new(10, 'EUR')).to be_truthy
      end
    end
  end
end
