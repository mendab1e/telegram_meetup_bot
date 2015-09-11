module TelegramMeetupBot
  class MessageParser
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def author
      from = message.from
      {id: from.id, username: from.username, first_name: from.first_name}
    end

    def command_with_params
      text = message.text

      if text[0] == '/' && text.length > 1
        words = text[1..-1].split(' ')
        {command: words.first, params: words.drop(1)}
      else
        {}
      end
    end
  end
end
