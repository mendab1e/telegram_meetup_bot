module TelegramMeetupBot
  module Commands
    class Base
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def exec
        fail NotImplementedError, 'This method should be overriden'
      end

      def command
        @command ||= if COMMANDS.include?(message.command)
          message.command
        else
          DEFAULT_COMMAND
        end
      end

      private

      def author
        message.author
      end

      def params
        message.params
      end

      def handle_date(date, &block)
        if date_has_error?(date)
          @error
        else
          yield
        end
      end

      def date_has_error?(date)
        if date.nil?
          @error = build_response(key: 'wrong_date_format')
        elsif date < Date.today
          @error = build_response(key: 'old_date')
        end
      end

      def list_response(args)
        empty_key = args.fetch(:empty_key) { 'nobody' }

        if args.fetch(:list).empty?
          build_response(args.merge(key: empty_key))
        else
          build_response(args) { |response| "#{response}\n#{args.fetch(:list)}" }
        end
      end

      def build_response(args = {})
        response_key = args.fetch(:key) { command }
        response = Initializers::ResponsesLoader.responses[response_key].dup
        response.gsub!('%first_name%', author.first_name)
        response.gsub!('%date%', args[:date].strftime('%d %h %Y')) if args[:date]
        response.gsub!('%date%', args[:month].strftime('%h %Y')) if args[:month]
        response.gsub!('%username%', args[:username]) if args[:username]

        block_given? ? yield(response) : response
      end
    end
  end
end
