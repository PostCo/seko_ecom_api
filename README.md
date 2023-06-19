# SekoEcomApi

An API wrapper gem for Seko OmniReturns

- OmniReturns

  - Shipment Creation

- OmniParcel

  - Available Rates

## Installation

Add this line to your application's Gemfile:

```ruby
gem "seko_ecom_api"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install seko_ecom_api

## Usage

### OmniReturns

```ruby
omni_returns_client = SekoEcomAPI::OmniReturnsClient.new(access_key: ENV['ACCESS_KEY'])

# Create shiment (or label creation)
omni_returns_client.create_shipment(params)

# Params' keys should be in snake case
# For example:
destination = {
	"address" : {
		"building_name" : "",
		"street_address": "123th St",
		"suburb": "Los Angeles",
		"city": "CA",
		"post_code": "90013",
		"country_code": "US"
	}
}
```

For testing purpose, you will need to set `test` to true
```ruby
omni_returns_client = SekoEcomAPI::OmniReturnsClient.new(access_key: ENV['ACCESS_KEY'], test: true)
```

For error handling, you might encounter SekoEcomAPI::Error and SekoEcomAPI::ParseError

```ruby
begin
	omni_returns_client.create_shipment(params)
rescue SekoEcomAPI::Error => err
	# The error message should be sufficient enough
rescue SekoEcomAPI::ParseError => err
	# Will be thrown if response's body is not in JSON format
	# Call response.body and response.headers to debug
	puts err.response.body
	puts err.response.headers
end
```

### OmniParcel

```ruby
omni_parcel_client = SekoEcomAPI::OmniParcelClient.new(access_key: ENV['ACCESS_KEY'])

# Retrieve rates
omni_parcel_client.retrieve_rates(params)
```

For error handle, there will only be SekoEcomAPI::Error with the Validation errors message

```ruby
begin
  omni_parcel_client.retrieve_rates(params)
rescue SekoEcomAPI::Error => err
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/seko_ecom_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/seko_ecom_api/blob/pc-2546-setup-sekoecomapi/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SekoEcomApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/seko_ecom_api/blob/pc-2546-setup-sekoecomapi/CODE_OF_CONDUCT.md).
