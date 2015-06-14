# LookAheadIterator

Ruby iterator with look ahead operations.

## Installation

Add this line to your application's Gemfile:

    gem 'look_ahead_iterator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install look_ahead_iterator

## Usage

```ruby
require 'look_ahead_iterator'
i = LookAheadIterator.new((1..4), stop: true)
loop do
  puts "Current_value: #{i.next.inspect}"
  puts "  (next value: #{i.look_ahead.inspect})"
end
```

## Contributing

1. Fork it ( https://github.com/jgoizueta/look_ahead_iterator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
