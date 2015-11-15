module Xmoney
  module Model
    include Comparable
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
      fail(UNKNOWN_CURRENCY, "Unknown currency [#{new_currency}]") unless current_currency[:conversions].key?(new_currency)
      converted_amount = amount * current_currency[:conversions][new_currency]
      self.class.new(converted_amount, new_currency)
    end

    def +(other)
      perform_math('+', other)
    end

    def -(other)
      perform_math('-', other)
    end

    def *(other)
      perform_math('*', other)
    end

    def /(other)
      perform_math('/', other)
    end

    def <=>(other)
      converted_amount = other.currency == currency ? other.amount : other.convert_to(currency).amount
      format_amount(amount).to_f <=> format_amount(converted_amount).to_f
    end

    private

    def perform_math(operation, other)
      converted_amount = other.currency == currency ? other.amount : other.convert_to(currency).amount
      tap do |instance|
        instance.amount = instance.amount.send("#{operation}".to_sym, converted_amount)
      end
    end

    def find_currency(currency)
      currencies.find { |cur| cur[:code] == currency }
    end

    def format_amount(number)
      '%g' % ('%.2f' % number)
    end
  end
end
