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
            if message.text
              messenger = Messenger.new(api: bot.api, chat_id: message.chat.id)
              CommandsHandler.new(message: message, messenger: messenger).process
            end
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        puts e
        sleep 1
        run # run again on telegram server error
      end
    end
  end
end
