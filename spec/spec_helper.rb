$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'xmoney'
require 'pry'

RSpec.configure do |config|

  config.before(:each) do
    Xmoney.reset!
  end

end
