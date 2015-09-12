module TelegramMeetupBot
  class Calendar
    attr_reader :storage, :user, :date, :time

    def initialize(args)
      @storage = args.fetch(:storage)
      @date = args.fetch(:date)
      @user = args.fetch(:user)
      @time = args[:time]
    end

    def add_user_to_date
      process_user do |users, saved_user|
        if saved_user
          if saved_user == user_hash
            return
          else
            users.delete(saved_user)
          end
        end

        users << user_hash
        storage.set_users_to_date(users, date)
      end
    end

    def delete_user_from_date
      process_user do |users, saved_user|
        if saved_user
          users.delete(saved_user)
          storage.set_users_to_date(users, date)
          true
        end
      end
    end

    private

    def process_user(&block)
      users = storage.get_users_for_date(date)
      saved_user = users.find { |u| u[:id] == user.id }

      yield users, saved_user
    end

    def user_hash
      @user_hash ||= if time
        user.to_h.merge(time: time)
      else
        user.to_h
      end
    end
  end
end
