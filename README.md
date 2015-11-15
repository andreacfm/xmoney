# Xmoney

Perform currency conversions, comparation and basic math operations between different currencies.

## Installation

```ruby
gem 'xmoney'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xmoney

## Usage

### Configure

Xmoney requires a set of currencies to be defined using the configure method.

```ruby
    Xmoney.configure do
      add_currency 'EUR', { 'USD' => 0.80 }
      add_currency 'USD', { 'EUR' => 1.20 }
    end
```

Use **add_currency** to make Xmoney aware of a new currency. The second argument defines the conversion rate between the defined currency 
and others.
 
 ### Namespace
 
 Since **Money** is a very common name Xmoney is designed to avoid polluting your environment. 
 Xmoney can be used directly or can be included into any Object of your choice:
  
  
```ruby

    Xmoney.new(10, 'USD').to_s # "10 USD"
    
    class MyMoney 
        include Xmoney::Model
    end    

    MyMoney.new(10, 'USD').to_s # "10 USD"
```

### What\'s inside?
