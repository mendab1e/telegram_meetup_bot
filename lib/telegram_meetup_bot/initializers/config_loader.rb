require 'redis'

module TelegramMeetupBot
  module Initializers
    class ConfigLoader < Base
      FILE_NAME = 'config.yml'
      AVAILABLE_KEYS = %w(bot_token redis_key redis_port redis_host)

      def redis
        @redis ||= Redis.new(
          host: configurations['redis_host'],
          port: configurations['redis_port']
        )
      end

      def configurations
        @configurations ||= begin
          config = YAML.load(File.open(@file).read)
          validate(config.keys)

          config
        end
      end

    end
  end
end
