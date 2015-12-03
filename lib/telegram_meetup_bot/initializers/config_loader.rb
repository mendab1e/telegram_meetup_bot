module TelegramMeetupBot
  module Initializers
    class ConfigLoader < Base
      EMPTY = ''
      FILE_NAME = 'config.yml'
      AVAILABLE_KEYS = %w(bot_token bot_name redis_key
        redis_port redis_host botan_key)

      class << self
        def storage
          @storage ||= Storage.new(redis: redis, redis_key: redis_key)
        end

        def token
          @configurations['bot_token']
        end

        def bot_name
          @configurations['bot_name']
        end

        def botan_key
          @key ||= if @configurations['botan_key'] == EMPTY
            nil
          else
            @configurations['botan_key']
          end
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
