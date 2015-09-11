require "telegram_meetup_bot/version"
require "telegram_meetup_bot/initializers"

module TelegramMeetupBot
  def self.run(config_path)
    messages = Initializers::MessagesLoader.new(config_path).load
    config = Initializers::ConfigLoader.new(config_path).load
    # Client.new(config_path).run
  end
end
