module TelegramMeetupBot
  class CallbackQueryParser < MessageParser
    private

    def parse_message(&block)
      if message.data && message.data[0] == '/' && message.data.length > 1
        yield message.data[1..-1].split(' ')
      end
    end
  end
end
