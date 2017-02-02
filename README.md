# Vx::Lib::Logger

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vx-lib-logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vx-lib-logger

## Usage

Add to your 'application.rb' file:

```ruby
    Vx::Lib::Logger.progname = ENV['PROGNAME']
    config.logger = Vx::Lib::Logger.get(ENV['STDOUT'] == '1' ? STDOUT : "log/#{Rails.env}.log")
```

Setup environment variables:

* for Logstash: `LOGSTASH_HOST`
* for Fluentd:  `FLUENT_HOST=hostname` and `FLUENT_PORT=24224`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vx-lib-logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
