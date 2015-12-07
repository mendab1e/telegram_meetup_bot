module TelegramMeetupBot
  module Commands
    class DateCommand < Base
      def exec
        handle_date(date) do
          Calendar.new(date: date, user: author, time: time).add_user_to_date
          build_response(date: date)
        end
      end

      private

      def date
        @parsed_date ||= ParamsParser.new(params.first).parse_date
        @parsed_date ||= Date.today if params.empty? || only_time_passed?
        @parsed_date
      end

      def only_time_passed?
        time && params.size == 1
      end

      def time
        @time ||= ParamsParser.new(params[1] || params[0]).parse_time
      end
    end
  end
end
