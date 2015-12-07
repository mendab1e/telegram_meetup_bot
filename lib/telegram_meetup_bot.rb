require 'telegram/bot'
require 'telegram/bot/botan'
require 'redis'

require 'telegram_meetup_bot/version'
require 'telegram_meetup_bot/initializers'
require 'telegram_meetup_bot/client'
require 'telegram_meetup_bot/messenger'
require 'telegram_meetup_bot/message_parser'
require 'telegram_meetup_bot/storage'
require 'telegram_meetup_bot/calendar'
require 'telegram_meetup_bot/commands_handler'
require 'telegram_meetup_bot/params_parser'
require 'telegram_meetup_bot/botan'
require 'telegram_meetup_bot/commands'

module TelegramMeetupBot
  def self.run(config_path)
    Initializers::ResponsesLoader.preload(config_path)
    Initializers::ConfigLoader.preload(config_path)

    Client.new(Initializers::ConfigLoader.token).run
  end
end
