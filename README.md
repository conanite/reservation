# Reservation

A gem for managing reservations. Provides the notion of "Event", which is basically an interval in time, and a
"Reservation", which is a many-to-many association model between Event and your objects.

There is no privileged event "owner", all associations are considered equivalent.

This gem uses ActiveRecord to store events and reservations

## Installation

Add this line to your application's Gemfile:

    gem 'reservation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reservation

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## license

MIT License
