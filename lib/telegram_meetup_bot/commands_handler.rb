module TelegramMeetupBot
  class CommandsHandler
    COMMANDS = %w(date list cancel help cal user)
    BLACK_LIST = %w(me)
    attr_reader :command, :params, :helper, :botan

    def initialize(args)
      parser = MessageParser.new(args.fetch(:message))
      @command = commands.include?(parser.command) ? parser.command : 'help'
      @params = parser.params
      @helper = HandlerHelper.new(
        author: parser.author,
        command: @command,
        messenger: args.fetch(:messenger)
      )
      @botan = args[:botan]
    end

    def process
      return if BLACK_LIST.include?(command)

      call_command(command)
      botan.track(command) if botan
      helper.send_empty_username_notification unless helper.author_has_username?
    end

    private

    def commands
      COMMANDS + BLACK_LIST
    end

    def call_command(command)
      if self.class.instance_method(command).arity == 0
        send command
      else
        send command, params
      end
    end

    # bot commands

    def date(params)
      date = ParamsParser.new(params.first).parse_date
      time = ParamsParser.new(params[1] || params[0]).parse_time
      date ||= Date.today if params.empty? || (time && params.size == 1)
      helper.handle_date(date, time)
    end

    def list(params)
      date = ParamsParser.new(params.first).parse_date
      date ||= Date.today if params.empty?
      helper.handle_date_list date
    end

    def cancel(params)
      date = ParamsParser.new(params.first).parse_date
      date ||= Date.today if params.empty?
      helper.handle_date_cancel date
    end

    def cal(params)
      month = ParamsParser.new(params.first).parse_month if params.any?
      month ||= Date.today.month
      helper.handle_cal month
    end

    def user(params)
      helper.handle_user params.first
    end

    def help
      helper.handle_default_command
    end
  end
end
