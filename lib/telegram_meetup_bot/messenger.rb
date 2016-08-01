module TelegramMeetupBot
  class Messenger
    attr_reader :api, :chat_id, :message_id

    def initialize(args)
      @api = args.fetch(:api)
      @chat_id = args.fetch(:chat_id)
      @message_id = args[:message_id]
    end

    def send_text(text, markup = nil)
      return if chat_id.nil?

      api.send_message(chat_id: chat_id,text: text,
        reply_markup: markup) rescue nil
    end

    def edit_text(text, markup = nil)
      return if chat_id.nil? || message_id.nil?

      api.edit_message_text(chat_id: chat_id, message_id: message_id,
        text: text, reply_markup: markup) rescue nil
    end
  end
end
