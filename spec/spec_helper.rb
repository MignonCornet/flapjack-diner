# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
  SimpleCov.coverage_dir 'coverage'
end

require 'webmock/rspec'

WebMock.disable_net_connect!(:allow_localhost => true)

require 'pact'
require 'pact/consumer/rspec'

$:.unshift(File.dirname(__FILE__) + '/../lib')

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Pact.service_consumer 'flapjack-diner' do

  has_pact_with "flapjack" do
    mock_service :flapjack do
      port 19081
    end
  end

end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
