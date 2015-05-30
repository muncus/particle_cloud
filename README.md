# ParticleCloud

Gem for interacting with [Particle](https://particle.io) Core/Photon devices through their [Cloud API](http://docs.particle.io/core/api/).

Right now, this code is largely unproven, as my particle devices have not yet arrived.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'particle_cloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install particle_cloud

## Usage

TODO: Write usage instructions here

`ParticleCloud::Device` allows for interaction with a single Particle device, given the device's id:

```ruby
dev1 = ParticleCloud::Device("access_token", "device_id")
dev1.device_info          # Returns info about the device
dev1.variable("foo")      # Get current value of variable "foo" exported by this device.
dev1.foo                  # Same as above.
dev1.function("bar", "arg1")     # Call the function "bar" on this device
dev1.bar("arg1")                 # Same as above.
```

`ParticleCloud::Client` is the base class of `ParticleCloud::Device`, and
includes methods for interacting with Particle Access Tokens
(http://docs.particle.io/core/api/#introduction-authentication).
Username and password are only required for methods that interact with Access
Tokens (this is a requirement of the Particle API).

```ruby
client = ParticleCloud::Client.new('token')
client.username = "your_particle.io_username"
client.password = "a_topsecret_password"
new_token = client.create_access_token()  # Create a new access token.
client.delete_access_token(new_token)     # And then delete it.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/muncus/particle_cloud/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
