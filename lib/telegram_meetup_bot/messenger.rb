module TelegramMeetupBot
  class Messenger
    attr_reader :api, :chat_id

    def initialize(args)
      @api = args.fetch(:api)
      @chat_id = args.fetch(:chat_id)
    end

    def send(text)
      api.send_message(chat_id: chat_id, text: text)
    end
  end
end
