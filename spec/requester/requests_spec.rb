require 'spec_helper'

RSpec.describe Requester::Requests do

  describe '(instance) request methods' do
    it 'implements the basic HTTP requests' do
      expect(described_class.instance_methods).to include(:xhr, :get, :put, :patch, :post, :delete, :head)
    end

    it 'logs request/response data' do
      ENV['REQUESTER'] = 'true'

      class FakeSpec
        prepend Requester::Requests
        def get(*args, **options); end
      end

      spec = FakeSpec.new
      expect(spec).to receive(:log_data).with({bar: 'baz'})
      spec.get '/foo', bar: 'baz'
    end
  end

  describe '#log_data' do
    it 'sends request/response data and options to the logger' do
      ENV['REQUESTER'] = 'true'

      class FakeSpec
        prepend Requester::Requests
        attr_accessor :controller, :request, :response
        def get(*args, **options)
          @controller = :some_controller
          @response = :some_response
          @request = :some_request
        end
      end

      expect(Requester::Logger).to receive(:log_response).with(:some_response, :some_controller, bar: 'baz')
      expect(Requester::Logger).to receive(:log_request).with(:some_request, :some_controller, bar: 'baz')

      FakeSpec.new.get '/foo', bar: 'baz'
    end
  end
end
