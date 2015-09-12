require 'redis'

module TelegramMeetupBot
  module Initializers
    class ConfigLoader < Base
      FILE_NAME = 'config.yml'
      AVAILABLE_KEYS = %w(bot_token redis_key redis_port redis_host)

      class << self
        def storage
          @storage ||= Storage.new(redis: redis, key: redis_key)
        end

        def token
          @configurations['bot_token']
        end

        private

        def redis_key
          @configurations['redis_key']
        end

        def redis
          @redis ||= Redis.new(
            host: @configurations['redis_host'],
            port: @configurations['redis_port']
          )
        end
      end

    end
  end
end
