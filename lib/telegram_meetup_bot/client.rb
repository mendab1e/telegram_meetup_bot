module TelegramMeetupBot
  class Client
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def run
      begin
        Telegram::Bot::Client.run(token) do |bot|
          bot.listen do |message|
            messenger = Messenger.new(api: bot.api, chat_id: message.chat.id)
            CommandsHandler.new(message: message, messenger: messenger).process
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        puts e
        run # run again on telegram server error
      end
    end
  end
end
