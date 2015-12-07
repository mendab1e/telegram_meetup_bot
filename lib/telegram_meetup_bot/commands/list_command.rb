module TelegramMeetupBot
  module Commands
    class ListCommand < Base
      def exec
        handle_date(date) do
          users = Calendar.formated_users_for_date(date)
          list_response(list: users, date: date)
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
