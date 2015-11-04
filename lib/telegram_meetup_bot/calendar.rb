module TelegramMeetupBot
  class Calendar
    attr_reader :storage, :user, :date, :time

    def initialize(args)
      @storage = Initializers::ConfigLoader.storage
      @date = args.fetch(:date)
      @user = args.fetch(:user)
      @time = args[:time]
    end

    def add_user_to_date
      process_user do |users, saved_user|
        return if saved_user == user_hash
        users.delete(saved_user) if saved_user
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

    def self.formated_users_for_date(date)
      storage = Initializers::ConfigLoader.storage
      users = storage.get_users_for_date(date)
      users.map! do |user|
        username = user[:username] ? " @#{user[:username]}" : ''
        "#{user[:first_name]}#{username} #{user[:time]}"
      end
      users.join("\n")
    end

    def self.submited_days_of_month(month)
      storage = Initializers::ConfigLoader.storage
      dates = storage.get_all_available_dates
      min, max = build_date_window(month)

      dates.keep_if { |date| date >= min && date <= max }.sort.
        map { |date| date.match(/\d\d$/) }.join(', ')
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

    def self.build_date_window(month)
      today = Date.today
      year = month < today.month ? today.next_year.year : today.year
      max = Date.new(year, month, -1).to_s
      min = today.month == month ? today.to_s : Date.new(year, month, 1).to_s

      [min, max]
    end
  end
end
