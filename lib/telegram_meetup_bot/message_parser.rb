module TelegramMeetupBot
  class MessageParser
    attr_reader :message
    User = Struct.new(:id, :username, :first_name)

    def initialize(message)
      @message = message
    end

    def author
      from = message.from
      User.new(from.id, from.username, from.first_name)
    end

    def chat_id
      message.chat.id
    end

    def command
      parse_message { |words| words.first }
    end

    def params
      parse_message { |words| words.drop(1) } || []
    end

    private

    def parse_message(&block)
      if message.text[0] == '/' && message.text.length > 1
        yield message.text[1..-1].split(' ')
      end
    end
  end
end
