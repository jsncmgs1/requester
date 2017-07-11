require 'json'

module Requester
  class Response

    def self.generate(response)
      new(response).json
    end

    def initialize(response)
      @response = response
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
