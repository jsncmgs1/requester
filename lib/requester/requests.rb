require_relative 'config'

module Requester
  module Requests
    REQUEST_TYPES = [
      :xhr, :get, :put, :patch, :post, :delete, :head
    ]

    REQUEST_TYPES.each do |method|
      define_method(method) do |*args, **options|
        super(*args)
        log_data(options) if ENV['REQUESTER']
      end
    end

    def log_data(**options)
      Logger.log_response(response, controller, options)
      Logger.log_request(request, controller, options)
    end

    def self.log_data(request:, response:, controller:, **options)
      return unless ENV['REQUESTER']
      Logger.log_response(response, controller, options)
      Logger.log_request(request, controller, options)
    end
  end
end
