require "bundler/setup"
require "requester"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  FakeResponse = Struct.new('Response',
    :status,
    :body,
    :message,
    :random_attr_one,
    :random_attr_two
  )

  FakeRequest = Struct.new('Request',
    :fullpath,
    :method,
    :request_parameters,
    :query_string,
    :media_type,
    :random_attr_one,
    :random_attr_two
  )

  FakeController = Struct.new('Controller',
    :action_name,
    :controller_name
  )

  class Time
    FakeTime = Struct.new('Zone', :now)

    def self.zone
      FakeTime.new("2017-07-11 16:51:08 -0400")
    end
  end

  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
