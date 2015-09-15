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

    def command
      parse_message do |words|
        cmd, bot_name = words.first.split('@')
        cmd if bot_name.nil? || bot_name == Initializers::ConfigLoader.bot_name
      end
    end

    def params
      parse_message { |words| words.drop(1) } || []
    end

    private

    def parse_message(&block)
      if message.text && message.text[0] == '/' && message.text.length > 1
        yield message.text[1..-1].split(' ')
      end
    end
  end
end
