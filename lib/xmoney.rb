require 'xmoney/version'
require 'xmoney/configuration'
require 'xmoney/model'
require 'xmoney/exceptions'

module Xmoney

  def self.new(amount,currency)
    Instance.new(amount,currency)
  end

  def self.configuration
    @_configuration ||= Configuration.new
  end

  def self.configure(&block)
    fail(MISSING_CONFIGURATION) unless block_given?
    self.configuration.setup(&block)
  end

  def self.currencies
    self.configuration.currencies
  end

  def self.reset!
    @_configuration = Configuration.new
  end

  class Instance
    include Xmoney::Model
  end

end
