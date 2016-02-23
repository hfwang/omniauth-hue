# OmniAuth Hue

An OmniAuth 1.0 strategy for Hue remote API integration.

Get your keys through the [Remote Hue API contact form](http://www.developers.meethue.com/content/remote-api)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-hue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-hue

## Usage

Once you have credentials from Hue, you could add the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :hue, ENV["HUE_CONSUMER_KEY"], ENV["HUE_CONSUMER_SECRET"], :app_id => ENV["HUE_APP_ID"], :device_id => "your app name", :device_name => "your app name"
end
```

Note the device ID and name parameters must be set, or the login form will not redirect back to your callback.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hfwang/omniauth-hue. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
