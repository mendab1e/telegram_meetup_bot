module TelegramMeetupBot
  module Initializers
    class ResponsesLoader < Base
      FILE_NAME = 'responses.yml'
      AVAILABLE_KEYS = %w(date list cancel wrong_date_format old_date nobody
        not_subscribed no_username help cal)

      def self.responses
        @configurations
      end
    end
  end
end
