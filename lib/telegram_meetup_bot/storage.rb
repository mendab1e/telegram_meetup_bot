module TelegramMeetupBot
  class Storage
    attr_reader :redis, :key

    def initialize(args)
      @redis = args.fetch(:redis)
      @key = args.fetch(:redis_key)
    end

    def get_users_for_date(date)
      users_yml = redis.hget(key, date)
      users_yml.nil? ? [] : YAML.load(users_yml)
    end

    def set_users_to_date(users, date)
      redis.hset(key, date, users.to_yaml)
    end

    def get_all_available_dates
      dates = redis.hgetall(key)
    end

    def delete_date(date)
      redis.hdel(key, date)
    end
  end
end
