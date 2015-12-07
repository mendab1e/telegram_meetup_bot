module TelegramMeetupBot
  module Commands
    class HelpCommand < Base
      def exec
        build_response
      end
    end
  end
end