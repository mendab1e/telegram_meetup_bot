module TelegramMeetupBot
  module Initializers
    class ResponsesLoader < Base
      FILE_NAME = 'responses.yml'
      AVAILABLE_KEYS = %w(today today_list today_cancel date date_list
        date_cancel wrong_date_format old_date nobody not_subscribed help)

      def self.responses
        @configurations
      end
    end
  end
end
