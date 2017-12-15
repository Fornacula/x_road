# XRoad

This gem simplifies the usage of X-Road services. Feel free to add new service classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'x_road'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install x_road

## Usage

First you need to generate certificate to connect to your X-Road security server.  
NB! Certifcate "Common Name" must be your server IP address or domain name.

    $ sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout certificate.key -out certificate.crt

Please forward certificate.crt to your X-Road security server administrator.

```ruby

require 'x_road'

XRoad.configure do |config|
  config.host = 'https://<your security server ip>/cgi-bin/consumer_proxy'
  config.client_cert = '/path/to/certificate.crt'
  config.client_key  = '/path/to/certificate.key'
  config.ssl_verify  = :peer # one of :none, :peer, :fail_if_no_peer_cert, :client_once
  config.log_level   = :debug # or one of :debug, :warn, :error, :fatal
  config.client_path = '<your server path>' # example: 'ee-test/NGO/90005872/harid' 
end

# Now you can check what methods are available for you:

response = XRoad::Rr.available_methods
response = XRoad::Ehis.available_methods
response = XRoad::Kpr.available_methods

```

## Supported Services

Ehis - Eesti Hariduse Infosüsteem (X-tee liidestus)
```ruby
response = XRoad::Ehis.available_methods
response = XRoad::Ehis.isiku_rollid('60510319579', user_id: 'EE60510319579')
```
More info about Rr at: https://www.riha.ee/Infos%C3%BCsteemid/Vaata/ehis

Rr - Rahvastikuregister (X-tee liidestus)
```ruby
response = XRoad::Rr.available_methods
response = XRoad::Rr.rr414('35001010036', user_id: 'EE35001010036')
```

More info about Rr at: https://www.riha.ee/Infos%C3%BCsteemid/Vaata/rr

More info at source code at lib/x_road/services/*.rb

## Contributors

* Janno Siilbek
* Priit Tark
* Jüri Punnar

## Contributing

1. Fork it ( https://github.com/gitlabeu/x_road/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
