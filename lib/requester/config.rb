module Requester
  class Config
    class RequesterConfigError < StandardError; end

    class << self
      attr_accessor :file_name, :library
      attr_reader :front_end_path, :additional_response_attributes, :additional_request_attributes

      def initialize(&block)
        @file_name = 'responses.js'
        @library = :rspec
        @additional_request_attributes = []
        @additional_response_attributes = []

        class_exec(self, &block)
      end

      def front_end_path=(path)
        @front_end_path = path

        unless valid_path_to_front_end_app?
          raise RequesterConfigError, config_error
        end
      end

      def additional_request_attributes=(*args)
        @additional_request_attributes = args.flatten
      end

      def additional_response_attributes=(*args)
        @additional_response_attributes = args.flatten
      end

      def back_end_path
        dir = library == :rspec ? 'spec' : 'test'
        File.join(Rails.root, dir)
      end

      def export_type
        :es6
      end

      private

      def valid_path_to_front_end_app?
        front_end_path && File.exist?(front_end_path)
      end

      def config_error
        <<-UIERROR
          \n *********************************************************
          \n Requester needs to know the path to your front end app
          \n *********************************************************
          \n
        UIERROR
      end
    end
  end
end
