module TelegramMeetupBot
  class Messenger
    attr_reader :api, :chat_id

    def initialize(args)
      @api = args.fetch(:api)
      @chat_id = args.fetch(:chat_id)
    end

    def send_text(text)
      api.send_message(chat_id: chat_id, text: text, reply_markup: keyboard)
    end

    private

    def keyboard
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [%w(/date /list /cal /cancel)],
        one_time_keyboard: false,
        resize_keyboard: true
      )
    end
  end
end
