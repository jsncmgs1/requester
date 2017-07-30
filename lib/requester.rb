require 'requester/version'
require 'requester/config'
require 'requester/logger'
require 'requester/requests'
require 'requester/railtie' if defined?(Rails)

module Requester
  include Requester::Requests
  extend Requester::Requests
end
