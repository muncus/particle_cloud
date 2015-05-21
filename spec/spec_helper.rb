$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'particle'

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/testdata/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {
    :record                 => :new_episodes,
    :allow_playback_repeats => true,
  }
  c.allow_http_connections_when_no_cassette = false
end

RSpec.configure do |config|
  # some (optional) config here
end
