module TelegramMeetupBot
  class CommandsHandler
    attr_reader :command, :botan, :messenger

    def initialize(args)
      parser = MessageParser.new(args.fetch(:message))
      @command = TelegramMeetupBot::Commands::Factory.build(parser)
      @messenger = args.fetch(:messenger)
      @botan = args[:botan]
    end

    def process
      if command
        messenger.send_text(command.exec)
        botan.track(command.command) if botan
      end
    end
  end
end
