module TelegramMeetupBot
  class CommandsHandler
    COMMANDS = %w(today today_list today_cancel date date_list date_cancel help)
    attr_reader :command, :params, :helper

    def initialize(args)
      parser = MessageParser.new(args.fetch(:message))
      @command = COMMANDS.include?(parser.command) ? parser.command : 'help'
      @params = parser.params
      @helper = HandlerHelper.new(
        author: parser.author,
        command: @command,
        messenger: args.fetch(:messenger)
      )
    end

    def process
      if method(command).arity == 0
        send command
      else
        send command, params
      end

      helper.send_empty_username_notification unless helper.author_has_username?
    end

    private

    def today(params)
      time = ParamsParser.new(params.first).parse_time if params.any?
      helper.handle_date(Date.today, time)
    end

    def date(params)
      date = ParamsParser.new(params.first).parse_date
      time = ParamsParser.new(params[1]).parse_time if params[1]
      helper.handle_date(date, time)
    end

    def today_list
      helper.handle_date_list Date.today
    end

    def date_list(params)
      date = ParamsParser.new(params.first).parse_date
      helper.handle_date_list date
    end

    def today_cancel
      helper.handle_date_cancel Date.today
    end

    def date_cancel(params)
      date = ParamsParser.new(params.first).parse_date
      helper.handle_date_cancel date
    end

    def help
      helper.handle_default_command
    end
  end
end
