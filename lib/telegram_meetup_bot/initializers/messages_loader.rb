module TelegramMeetupBot
  module Initializers
    class MessagesLoader < Base
      FILE_NAME = 'messages.yml'
      AVAILABLE_KEYS = %w(today today_list today_cancel date date_list
        date_cancel wrong_date_format old_date nobody not_subscribed help)

      def load
        messages = YAML.load(File.open(@file).read)
        validate(messages.keys)

        messages
      end
    end
  end
end
