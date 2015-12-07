module TelegramMeetupBot
  module Commands
    class NilUsername < Base
      def exec
        build_response(key: 'no_username')
      end
    end
  end
end
