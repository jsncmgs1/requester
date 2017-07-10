require_relative 'config'

module Requester
  class Request
    def self.generate(request, options)
      new(request, options).json
    end

    def initialize(request, **options)
      @request = request
      @config = Requester::Config
      @json = {
        path: request.fullpath,
        method: request.method
      }.with_indifferent_access
    end

    def json
      @json.tap do |json|
        json[:request_parameters] = @request.request_parameters if @request.request_parameters.present?
        json[:query_string] = @request.query_string if @request.query_string.present?
        json[:media_type] = @request.media_type if @request.media_type.present?
      end
    end
  end
end
