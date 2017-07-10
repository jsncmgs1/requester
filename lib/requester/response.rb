module Requester
  class Response
    attr_reader :json

    def self.generate(response, **options)
      new(response, options).json
    end

    def initialize(response, **options)
      @response = response
      @config = Requester::Config
      @json = {
        status: response.status,
        body: JSON.parse(response.body),
        message: response.message
      }.with_indifferent_access
    end
  end
end
