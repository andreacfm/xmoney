require 'spec_helper'

describe Xmoney do
  describe 'configure' do
    context 'with valida data' do
      before do
        Xmoney.conversion_rates do
          add_currency 'EURO', { 'USD' => 0.80 }
          add_currency 'USD', { 'EURO' => 1.20 }
        end
      end

      specify do
        expect(Xmoney.configuration.currencies.count).to eq(2)
        expect(Xmoney.configuration.currencies.find { |cur| cur[:code] == 'EURO' }[:conversions]).to eq({ 'USD' => 0.80 })
        expect(Xmoney.configuration.currencies.find { |cur| cur[:code] == 'USD' }[:conversions]).to eq({ 'EURO' => 1.20 })
      end
    end

    context 'with missing config' do
      specify do
        expect { Xmoney.conversion_rates }.to raise_error Xmoney::MISSING_CONFIGURATION
      end
    end
  end
end
