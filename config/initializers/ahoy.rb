class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Better user agent parsing
Ahoy.user_agent_parser = :device_detector

# Mask IPs for privacy
Ahoy.mask_ips = true

# Track visits and events
Ahoy.track_bots = false

# Use server-side tracking (no cookies needed)
Ahoy.cookies = :none
