module TelegramMeetupBot
  class HandlerHelper
    attr_reader :command, :author, :messenger, :error

    def initialize(args)
      @command = args.fetch(:command)
      @author = args.fetch(:author)
      @messenger = args.fetch(:messenger)
    end

    def handle_date(date, time)
      handle(date) do
        Calendar.new(date: date, user: author, time: time).add_user_to_date
        messenger.send_text build_response(date: date)
      end
    end

    def handle_date_list(date)
      handle(date) do
        users = Calendar.formated_users_for_date(date)
        messenger.send_text list_response(list: users, date: date)
      end
    end

    def handle_date_cancel(date)
      handle(date) do
        calendar = Calendar.new(date: date, user: author)
        deleted_user = calendar.delete_user_from_date
        args = deleted_user ? {} : {key: 'not_subscribed', date: date}
        messenger.send_text build_response(args)
      end
    end

    def handle_default_command
      messenger.send_text build_response
    end

    def send_empty_username_notification
      messenger.send_text build_response(key: 'no_username')
    end

    def author_has_username?
      author.username
    end

    def handle_cal(month)
      dates = Calendar.submited_days_of_month(month)
      today = Date.today
      year = month < today.month ? today.next_year.year : today.year
      month = Date.new(year, month)
      messenger.send_text list_response(list: dates, month: month)
    end

    private

    def handle(date, &block)
      if date_has_error?(date)
        messenger.send_text error
      else
        yield
      end
    end

    def date_has_error?(date)
      if date.nil?
        @error = build_response(key: 'wrong_date_format')
      elsif date < Date.today
        @error = build_response(key: 'old_date')
      end
    end

    def list_response(args)
      if args.fetch(:list).empty?
        build_response(args.merge(key: 'nobody'))
      else
        build_response(args) { |response| "#{response}\n#{args.fetch(:list)}" }
      end
    end

    def build_response(args = {})
      response_key = args.fetch(:key) { command }
      response = Initializers::ResponsesLoader.responses[response_key].dup
      response.gsub!('%first_name%', author.first_name)
      response.gsub!('%date%', args[:date].strftime('%d %h %Y')) if args[:date]
      response.gsub!('%date%', args[:month].strftime('%h %Y')) if args[:month]

      block_given? ? yield(response) : response
    end
  end
end
