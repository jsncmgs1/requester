require 'spec_helper'

RSpec.describe Requester::Logger do
  describe '.log_response' do
    before do
      described_class.instance_variable_set(:@log, {})
    end

    it 'creates a JS object based on the controller and action' do
      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":1,\"name\":\"Bob\"}]}", 'OK')

      described_class.log_response(response, controller)
      expected = {"users"=>
                   {"index"=>
                    {"response"=>
                     {:status=>200,
                      :body=>{"users"=>[{"id"=>1, "name"=>"Bob"}]},
                      :message=>"OK"}}}}
      expect(described_class.log).to eq(expected)
    end

    it 'adds an additional key nesting when options[:log_as] is specified' do
      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":1,\"name\":\"Bob\"}]}", 'OK')
      described_class.log_response(response, controller)

      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":2,\"name\":\"John\"}]}", 'OK')
      described_class.log_response(response, controller, log_as: 'with search params')

      expected = {"users"=>
                  {"index"=>
                   {"response"=>
                    {:status=>200,
                     :body=>{"users"=>[{"id"=>1, "name"=>"Bob"}]},
                     :message=>"OK"},
                     "with search params"=>
                       {"response"=>
                         {:status=>200,
                          :body=>{"users"=>[{"id"=>2, "name"=>"John"}]},
                          :message=>"OK"}}}}}

      expect(described_class.log).to eq(expected)
    end

    it "won't override an existing key" do
      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":1,\"name\":\"Bob\"}]}", 'OK')
      described_class.log_response(response, controller)

      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":2,\"name\":\"John\"}]}", 'OK')
      described_class.log_response(response, controller)

      expected = {"users"=>
                   {"index"=>
                    {"response"=>
                     {:status=>200,
                      :body=>{"users"=>[{"id"=>1, "name"=>"Bob"}]},
                      :message=>"OK"}}}}
      expect(described_class.log).to eq(expected)
    end
  end

  describe 'dump' do
    it 'generates a JSON representation of the log and dumps it to the back end and front end paths' do
      ENV['REQUESTER'] = 'true'

      path = "#{Pathname.pwd.to_path}/spec"
      front_end_path = path + '/front_end_path/responses.js'
      back_end_path = path + '/back_end_path/responses.js'
      test_path = path + '/final_dump.js'
      File.delete(front_end_path) if File.exist?(front_end_path)
      File.delete(back_end_path) if File.exist?(back_end_path)

      allow(Requester::Config).to receive(:back_end_path) { path + '/back_end_path' }
      allow(Requester::Config).to receive(:front_end_path) { path + '/front_end_path' }

      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":1,\"name\":\"Bob\"}]}", 'OK')
      described_class.log_response(response, controller)

      controller = FakeController.new('index', 'users')
      response = FakeResponse.new(200, "{\"users\":[{\"id\":2,\"name\":\"John\"}]}", 'OK')
      described_class.log_response(response, controller, log_as: 'with search params')

      expected = {"users"=>
                  {"index"=>
                   {"response"=>
                    {:status=>200,
                     :body=>{"users"=>[{"id"=>1, "name"=>"Bob"}]},
                     :message=>"OK"},
                     "with search params"=>
                       {"response"=>
                         {:status=>200,
                          :body=>{"users"=>[{"id"=>2, "name"=>"John"}]},
                          :message=>"OK"}}}}}
      described_class.dump

      expect(File.exist?(front_end_path)).to be true
      expect(File.exist?(back_end_path)).to be true

      final_file_dump = File.read(test_path)
      expect(File.read(front_end_path)).to eq(final_file_dump)
      expect(File.read(back_end_path)).to eq(final_file_dump)

      File.delete(front_end_path)
      File.delete(back_end_path)
    end
  end
end
