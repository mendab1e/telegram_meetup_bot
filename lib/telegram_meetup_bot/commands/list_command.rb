module TelegramMeetupBot
  module Commands
    class ListCommand < Base
      def exec
        response = handle_date(date) do
          users = Calendar.formated_users_for_date(date)
          list_response(list: users, date: date)
        end

        [response, build_reply_markup]
      end

      private

      def date
        @parsed_date ||= ParamsParser.new(params.first).parse_date
        @parsed_date ||= Date.today if params.empty?
        @parsed_date
      end

      def build_reply_markup
        keys = [[previous_day_key, next_day_key].compact]

        Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keys)
      end

      def previous_day_key
        return nil if date == Date.today

        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: '⬅️',
          callback_data: "/list #{(date - 1).strftime('%d.%m.%y')}"
        ) rescue nil
      end

      def next_day_key
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: '➡️',
          callback_data: "/list #{(date + 1).strftime('%d.%m.%y')}"
        ) rescue nil
      end
    end
  end
end
