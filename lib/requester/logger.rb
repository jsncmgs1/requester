require_relative 'request'
require_relative 'response'

module Requester
  class Logger
    class << self
      def log
        @log ||= {}
      end

      def log_response(response, controller, **options)
        c_name = controller.controller_name
        a_name = controller.action_name
        log_as = options[:log_as]

        log[c_name] ||= {}
        log[c_name][a_name] ||= {}

        json = Requester::Response.generate(response, options)

        if options[:log_as]
          log[c_name][a_name][log_as] ||= {}
          log[c_name][a_name][log_as]['response'] = json
        else
          log[c_name][a_name]['response'] = json
        end
      end

      def log_request(request, controller, **options)
        c_name = controller.controller_name
        a_name = controller.action_name
        log_as = options[:log_as]

        log[c_name] ||= {}
        log[c_name][a_name] ||= {}

        json = Requester::Request.generate(request, options)

        if log_as
          log[c_name][a_name][log_as] ||= {}
          log[c_name][a_name][log_as]['request'] = json
        else
          log[c_name][a_name]['request'] = json
        end
      end

      def dump
        return unless ENV['REQUESTER']

        api_dump = File.new(back_end_file, 'w+')
        ui_dump = File.new(front_end_file, 'w+')
        json = JSON.pretty_generate(log)

        # would like to support other types as well
        case Requester::Config.export_type
        when :es6
          ui_dump.write(es6_export + json)
          api_dump.write(es6_export + json)
        end

        puts <<-DUMP
          \n**************************
          \n Interceptor logs dumped at:
          \n #{File.expand_path(front_end_file)}
          \n #{File.expand_path(back_end_file)}
          \n**************************
        DUMP
      ensure
        api_dump.close if api_dump
        ui_dump.close if ui_dump
      end

      private

      def es6_export
        "//#{Time.zone.now}\n\nexport default "
      end

      def front_end_file
        File.join(Requester::Config.front_end_path, Requester::Config.file_name)
      end

      def back_end_file
        File.join(Requester::Config.back_end_path, Requester::Config.file_name)
      end
    end
  end
end
