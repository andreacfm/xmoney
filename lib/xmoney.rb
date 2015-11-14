require 'xmoney/version'
require 'xmoney/configuration'

module Xmoney
  MISSING_CONFIGURATION = Class.new(StandardError)

  class << self
    attr_accessor :configuration
  end

  def self.configure(&block)
    fail(MISSING_CONFIGURATION) unless block_given?
    self.configuration ||= Configuration.new
    self.configuration.setup(&block)
  end

  def self.currencies
    self.configuration.currencies
  end
end
