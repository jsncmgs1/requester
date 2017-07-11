module Requester
  class Response

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
      }
    end

    def json
      @json.tap do |json|
        Requester::Config.additional_response_attributes.each do |attr|
          json[attr] = @response.public_send(attr)
        end
      end
    end
  end
end
