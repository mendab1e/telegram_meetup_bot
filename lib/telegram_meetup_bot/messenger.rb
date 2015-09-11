module TelegramMeetupBot
  class Messenger
    attr_reader :api

    def initialize(api)
      @api = api
    end

    def send(args)
      chat_id = args.fetch(:chat_id)
      text = args.fetch(:text)

      api.send_message(chat_id: chat_id, text: text)
    end
  end
end
