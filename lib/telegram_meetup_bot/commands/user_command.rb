module TelegramMeetupBot
  module Commands
    class UserCommand < Base
      def exec
        dates = Calendar.submited_days_by_user(username)
        list_response(list: dates, month: Date.today, username: username,
          empty_key: 'user_without_reservation')
      end

      private

      def username
        params.first || author.username
      end
    end
  end
end