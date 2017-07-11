require 'spec_helper'

RSpec.describe Requester::Response do
  FakeResponse = Struct.new('Request',
    :status,
    :body,
    :message,
    :random_attr_one,
    :random_attr_two
  )

  class JSON
    def self.parse(string); string end
  end

  describe '.generate' do
    it 'creates a json object with status, body, and message attributes' do
      response = FakeResponse.new(200, {foo: 'bar'}, 'Winter is coming')
      actual = described_class.generate(response)
      expected = {
        status: 200,
        body: {:foo => 'bar'},
        message: 'Winter is coming'
      }

      expect(actual).to eq(expected)
    end

    it 'gets additional attributes specified in config' do
      Requester::Config.additional_response_attributes = :random_attr_one, :random_attr_two
      response = FakeResponse.new(
        200,
        {foo: 'bar'},
        'Winter is coming',
        'extra value one',
        'extra value two'
      )

      actual = described_class.generate(response)

      expected = {
        status: 200,
        body: {:foo => 'bar'},
        message: 'Winter is coming',
        random_attr_one: 'extra value one',
        random_attr_two: 'extra value two'
      }
      expect(actual).to eq(expected)
    end
  end
end
