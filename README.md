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

### What's inside?

```ruby

Xmoney.configure do
    add_currency 'EUR', { 'USD' => 0.80 }
    add_currency 'USD', { 'EUR' => 1.20 }
end

class Money 
    include Xmoney::Model
end    

ten_eur = Money.new(10, 'EUR')
ten_usd = Money.new(10, 'USD')

# Instance
ten_eur.amount #=> "10"
ten_eur.currency #=> "EUR"
ten_eur.to_s #=> "10 EUR"

# Maths
(ten_eur + ten_usd).to_s #=> '22 EUR' 
(ten_usd - ten_eur).to_s #=> '2 USD' 
(ten_eur * ten_usd).to_s #=> '120 EUR' 
(ten_usd / ten_eur).to_s #=> '1.25 USD'

# Conversions
Xmoney.new(10, 'USD').convert_to('EUR') #=> '12 EUR'

```

## Specs

```ruby
bundle exec rake rspec
```



