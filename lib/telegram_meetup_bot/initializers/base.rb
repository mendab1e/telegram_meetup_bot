module TelegramMeetupBot
  module Initializers
    class Base
      def initialize(config_path)
        @file = File.join(config_path, self.class::FILE_NAME)
        check_if_exist
      end

      private

      def check_if_exist
        unless File.exist? @file
          puts "Error: file not found #{@file}"
          exit
        end
      end

      def validate(keys)
        missing_keys = self.class::AVAILABLE_KEYS - keys

        if missing_keys.any?
          puts "Error: missing params in #{@file}\n#{missing_keys.join(', ')}"
          exit
        end
      end
    end
  end
end
