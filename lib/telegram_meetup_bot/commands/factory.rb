module TelegramMeetupBot
  module Commands
    class Factory
      COMMANDS = %w(date list cancel help cal user)
      BLACK_LIST = %w(me)
      DEFAULT_COMMAND = 'help'

      class << self
        def build(message)
          return if BLACK_LIST.include?(message.command)
          klass(message.command).new(message)
        end

        private

        def klass(command)
          command = whitelisted_command(command).capitalize
          Object.const_get "TelegramMeetupBot::Commands::#{command}"
        end

        def whitelisted_command(command)
          COMMANDS.include?(command) ? command : DEFAULT_COMMAND
        end
      end
    end
  end
end
