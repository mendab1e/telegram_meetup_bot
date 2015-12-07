module TelegramMeetupBot
  module Commands
    class CalCommand < Base
      def exec
        dates = Calendar.submited_days_of_month(month)
        list_response(list: dates, month: month_with_year)
      end

      private

      def month
        @month ||= ParamsParser.new(params.first).parse_month if params.any?
        @month ||= Date.today.month
        @month
      end

      def month_with_year
        today = Date.today
        year = month < today.month ? today.next_year.year : today.year
        Date.new(year, month)
      end
    end
  end
end
