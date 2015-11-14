module Xmoney
  module Model
    attr_accessor :amount, :currency
    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end
  end
end
