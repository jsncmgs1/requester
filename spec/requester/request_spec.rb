require "spec_helper"

RSpec.describe Requester::Request do
  describe '.generate' do
    it 'creates a json object with path and method attributes' do
      request = FakeRequest.new('/foo', 'GET')
      json = described_class.generate(request)

      expect(json).to eq({path: '/foo', method: 'GET'})
    end

    it 'adds request_parameters, query_string, media_type if present' do
      request = FakeRequest.new('/foo', 'GET', 'bar', 'baz', 'bux')
      actual = described_class.generate(request)
      expected = {
        path: '/foo',
        method: 'GET',
        request_parameters: 'bar',
        query_string: 'baz',
        media_type: 'bux'
      }

      expect(actual).to eq(expected)
    end

    it 'gets additional attributes specified in config' do
      Requester::Config.additional_request_attributes = :random_attr_one, :random_attr_two

      request = FakeRequest.new(
        '/foo',
        'GET',
        'bar',
        'baz',
        'bux',
        'extra value one',
        'extra value two'
      )

      actual = described_class.generate(request)

      expected = {
        path: '/foo',
        method: 'GET',
        request_parameters: 'bar',
        query_string: 'baz',
        media_type: 'bux',
        random_attr_one: 'extra value one',
        random_attr_two: 'extra value two',
      }

      expect(actual).to eq(expected)
    end
  end
end
