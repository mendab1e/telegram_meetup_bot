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

    def command_with_params
      if message.text[0] == '/' && message.text.length > 1
        words = message.text[1..-1].split(' ')
        {command: words.first, params: words.drop(1)}
      else
        {}
      end
    end
  end
end
