module TelegramMeetupBot
  module Initializers
    class Base
      private

      class << self
        def preload(config_path)
          @configurations ||= begin
            file = File.join(config_path, self::FILE_NAME)
            check_if_exist(file)
            config = YAML.load(File.open(file).read)
            validate(config.keys, file)

            config
          end
        end

        def check_if_exist(file)
          unless File.exist? file
            puts "Error: file not found #{file}"
            exit
          end
        end

        def validate(keys, file)
          missing_keys = self::AVAILABLE_KEYS - keys

          if missing_keys.any?
            puts "Error: missing params in #{file}\n#{missing_keys.join(', ')}"
            exit
          end
        end
      end

    end
  end
end
