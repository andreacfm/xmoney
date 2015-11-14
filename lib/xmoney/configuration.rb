module Xmoney
  class Configuration
    attr_accessor :currencies

    def initialize
      @currencies = []
    end

    def setup(&block)
      instance_eval(&block)
    end

    def add_currency(code, conversions)
      currencies << { code: code, conversions: conversions }
    end
  end
end
