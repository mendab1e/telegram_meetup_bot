module TelegramMeetupBot
  class Botan
    attr_reader :bot, :author_id

    def initialize(args)
      @bot = args.fetch(:bot)
      @author_id = args.fetch(:author_id)
    end

    def track(command)
      bot.track(command, author_id)
    end
  end
end
