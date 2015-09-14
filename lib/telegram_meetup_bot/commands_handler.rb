module TelegramMeetupBot
  class CommandsHandler
    COMMANDS = %w(today today_list today_cancel date date_list date_cancel help)
    attr_reader :command, :params, :author, :messenger

    def initialize(args)
      parser = MessageParser.new(args.fetch(:message))
      @messenger = args.fetch(:messenger)
      @command = COMMANDS.include?(parser.command) ? parser.command : 'help'
      @params = parser.params
      @author = parser.author
    end

    def process
      if method(command).arity == 0
        send command
      else
        send command, params
      end
    end

    private

    def today(params)
      handle_date Date.today
    end

    def date(params)
      date = ParamsParser.new(params.first).parse_date
      handle_date(date) if date_is_valid?(date)
    end

    def handle_date(date)
      Calendar.new(date: date, user: author).add_user_to_date
      messenger.send build_response(date: date)
    end

    def today_list
      handle_date_list Date.today
    end

    def date_list(params)
      date = ParamsParser.new(params.first).parse_date
      handle_date_list(date) if date_is_valid?(date)
    end

    def handle_date_list(date)
      users = Calendar.formated_users_for_date(date)
      messenger.send list_response(date, users)
    end

    def today_cancel
      handle_date_cancel Date.today
    end

    def date_cancel(params)
      date = ParamsParser.new(params.first).parse_date
      handle_date_cancel(date) if date_is_valid?(date)
    end

    def handle_date_cancel(date)
      calendar = Calendar.new(date: date, user: author)
      deleted = calendar.delete_user_from_date
      args = deleted ? {} : {key: 'not_subscribed', date: date}
      messenger.send build_response(args)
    end

    def help
      messenger.send build_response
    end

    def date_is_valid?(date)
      if date.nil?
        messenger.send build_response(key: 'wrong_date_format')
        return false
      elsif date < Date.today
        messenger.send build_response(key: 'old_date')
        return false
      end
      true
    end

    def list_response(date, list)
      if list.empty?
        build_response(key: 'nobody', date: date)
      else
        build_response(date: date) { |response| "#{response}\n#{list}" }
      end
    end

    def build_response(args = {})
      response_key = args.fetch(:key) { command }
      response = Initializers::ResponsesLoader.responses[response_key]
      response.gsub!('%first_name%', author.first_name)
      response.gsub!('%date%', args[:date].strftime('%d %h %Y')) if args[:date]

      block_given? ? yield(response) : response
    end
  end
end
