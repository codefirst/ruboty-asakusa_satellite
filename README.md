# Ruboty::AsakusaSatellite
AsakusaSatellite adapter for [Ruboty](https://github.com/r7kamura/ruboty).
Now only supports [Keima](http://www.codefirst.org/keima/) adapter.

```ruby
# Gemfile
gem 'websocket-client-simple', github: 'mallowlabs/websocket-client-simple', branch: 'ssl'
gem 'socket.io-client-simple', github: 'mallowlabs/ruby-socket.io-client-simple', branch: 'query-parameter'
gem "ruboty-asakusa-satellite", github: 'codefirst/ruboty-asakusa-satellite'
```

## ENV
```
ASAKUSA_SATELLITE_URL      - AsakusaSatellite URL (e.g. http://asakusa-satellite.org)
ASAKUSA_SATELLITE_ROOM     - Room name to join in at first (e.g. general)
ASAKUSA_SATELLITE_USERNAME - Account's username (e.g. alice)
ASAKUSA_SATELLITE_API_KEY  - Account's API Key
```
