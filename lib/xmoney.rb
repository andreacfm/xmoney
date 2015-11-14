require 'xmoney/version'
require 'xmoney/configuration'
require 'xmoney/model'

module Xmoney
  MISSING_CONFIGURATION = Class.new(StandardError)

  class << self
    attr_accessor :configuration
  end

  def self.new(amount,currency)
    Instance.new(amount,currency)
  end

  def self.conversion_rates(&block)
    fail(MISSING_CONFIGURATION) unless block_given?
    self.configuration ||= Configuration.new
    self.configuration.setup(&block)
  end

  def self.currencies
    self.configuration.currencies
  end

  class Instance
    include Xmoney::Model
  end

end
