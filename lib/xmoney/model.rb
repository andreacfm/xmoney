module Xmoney
  module Model
    attr_accessor :amount, :currency

    def initialize(amount, currency)
      @amount = amount
      @currency = currency
      fail(UNKNOWN_CURRENCY, "Unknown currency [#{currency}]") if find_currency(@currency).nil?
    end

    def currencies
      Xmoney.currencies
    end

    def to_s
      "#{format_amount(amount)} #{currency}"
    end

    def convert_to(new_currency)
      current_currency = find_currency(currency)
      fail(UNKNOWN_CURRENCY, "Unknown currency [#{new_currency}]") unless current_currency[:conversions].has_key?(new_currency)
      converted_amount  = amount * current_currency[:conversions][new_currency]
      self.class.new(converted_amount, new_currency)
    end

    def +(xmoney)
      converted_amount = xmoney.convert_to(currency).amount
      self.tap do |instance|
        instance.amount += converted_amount
      end
    end

    def -(xmoney)
      converted_amount = xmoney.convert_to(currency).amount
      self.tap do |instance|
        instance.amount -= converted_amount
      end
    end

    def *(xmoney)
      converted_amount = xmoney.convert_to(currency).amount
      self.tap do |instance|
        instance.amount *= converted_amount
      end
    end

    private

    def find_currency(currency)
      currencies.find { |cur| cur[:code] == currency }
    end

    def format_amount(number)
      '%g' % ('%.2f' % number)
    end

  end
end
