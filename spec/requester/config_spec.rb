require "spec_helper"
require 'rspec/mocks'

RSpec.describe Requester::Config do
  before do
    described_class.initialize {}
  end

  describe 'default attributes' do
    it 'uses rspec' do
      expect(described_class.library).to eq(:rspec)
    end

    it 'names the js output "responses.js"' do
      expect(described_class.file_name).to eq('responses.js')
    end

    it 'uses es6 exports' do
      expect(described_class.export_type).to eq(:es6)
    end

    it 'has an empty array for additional_response_attributes' do
      expect(described_class.additional_response_attributes).to eq([])
    end

    it 'has an empty array for additional_request_attributes' do
      expect(described_class.additional_request_attributes).to eq([])
    end
  end

  describe '.back_end_path' do
    before do
      class Rails; end
      allow(Rails).to receive(:root) { '/Users/me/code/some_project' }
    end

    it 'points to the spec folder when using RSpec' do
      expect(described_class.back_end_path).to eq('/Users/me/code/some_project/spec')
    end

    it 'points to test when not using RSpec' do
      described_class.library = :foo
      expect(described_class.back_end_path).to eq('/Users/me/code/some_project/test')
    end
  end

  describe '.front_end_path' do
    it 'raises RequesterConfigError if front_end_path is not valid' do
      expect { described_class.front_end_path = '/foo' }
        .to raise_error(Requester::Config::RequesterConfigError)
    end
  end

  describe '.initialization' do
    it 'yields the class for configuration' do
      described_class.initialize do |config|
        config.library = :foo
      end

      expect(described_class.library).to eq(:foo)
    end
  end
end
