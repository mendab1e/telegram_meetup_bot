module TelegramMeetupBot
  class CommandsHandler
    attr_reader :command, :botan, :messenger, :mode

    def initialize(args)
      parser = build_parser(args)
      @command = TelegramMeetupBot::Commands::Factory.build(parser)
      @messenger = args.fetch(:messenger)
      @botan = args[:botan]
    end

    def process
      if command && mode == :send
        messenger.send_text(*command.exec)
        botan.track(command.command) if botan
      elsif command && mode == :edit
        messenger.edit_text(*command.exec)
      end
    end

    private

    def build_parser(args)
      if args[:message]
        @mode = :send
        MessageParser.new(args[:message])
      elsif args[:callback_query]
        @mode = :edit
        CallbackQueryParser.new(args[:callback_query])
      end
    end
  end
end
