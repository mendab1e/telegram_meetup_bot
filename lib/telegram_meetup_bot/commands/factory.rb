module TelegramMeetupBot
  module Commands
    class Factory
      class << self
        def build(message)
          return if BLACK_LIST.include?(message.command)

          if no_username?(message)
            TelegramMeetupBot::Commands::NilUsername.new(message)
          else
            klass(message.command).new(message)
          end
        end

        private

        def klass(command)
          command = whitelisted_command(command).capitalize
          Object.const_get "TelegramMeetupBot::Commands::#{command}Command"
        end

        def whitelisted_command(command)
          COMMANDS.include?(command) ? command : DEFAULT_COMMAND
        end

        def no_username?(message)
          message.author.username.nil?
        end
      end
    end
  end
end
