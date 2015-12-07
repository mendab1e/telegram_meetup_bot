module TelegramMeetupBot
  module Commands
    class CancelCommand < Base
      def exec
        handle_date(date) do
          calendar = Calendar.new(date: date, user: author)
          deleted_user = calendar.delete_user_from_date
          args = deleted_user ? {} : {key: 'not_subscribed', date: date}
          build_response(args)
        end
      end

      private

      def date
        @parsed_date ||= ParamsParser.new(params.first).parse_date
        @parsed_date ||= Date.today if params.empty?
        @parsed_date
      end
    end
  end
end