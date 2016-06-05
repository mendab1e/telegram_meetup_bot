module TelegramMeetupBot
  class Client
    TIMEOUT = 1

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def run
      Telegram::Bot::Client.run(token) do |bot|
        bot.enable_botan!(botan_key) if botan_key
        bot.listen do |message|
          case message
          when Telegram::Bot::Types::Message
            process_message(bot, message) if message.text
          when Telegram::Bot::Types::CallbackQuery
            process_callback_query(bot, message) if message.data
          end
        end
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      write_log_and_sleep(e)
      retry # run again on telegram server error
    end

    private

    def process_message(bot, message)
      messenger = Messenger.new(api: bot.api, chat_id: message.chat.id)
      botan = Botan.new(bot: bot, author_id: message.from.id) if botan_key

      CommandsHandler.new(
        message: message,
        messenger: messenger,
        botan: botan
      ).process
    end

    def process_callback_query(bot, callback_query)
      messenger = Messenger.new(api: bot.api,
        chat_id: callback_query.message.chat.id,
        message_id: callback_query.message.message_id)

      CommandsHandler.new(
        callback_query: callback_query,
        messenger: messenger
      ).process
    end

    def botan_key
      Initializers::ConfigLoader.botan_key
    end

    def write_log_and_sleep(error)
      puts "#{Time.now}: #{error}"
      sleep TIMEOUT
    end
  end
end
