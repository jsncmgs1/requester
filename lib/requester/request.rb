require_relative 'config'

module Requester
  class Request
    def self.generate(request, **options)
      new(request, options).json
    end

    def initialize(request, **options)
      @request = request
      @config = Requester::Config
      @json = {
        path: request.fullpath,
        method: request.method
      }
    end

    def json
      @json.tap do |json|
        json[:request_parameters] = @request.request_parameters if @request.request_parameters
        json[:query_string] = @request.query_string if @request.query_string
        json[:media_type] = @request.media_type if @request.media_type

        Requester::Config.additional_request_attributes.each do |attr|
          json[attr] = @request.public_send(attr)
        end
      end
    end
  end
end
