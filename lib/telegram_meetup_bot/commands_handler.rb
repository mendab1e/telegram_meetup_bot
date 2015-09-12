module TelegramMeetupBot
  class CommandsHandler
    COMMANDS = %w(today today_list today_cancel date date_list date_cancel help)
    attr_reader :command, :params, :author, :messenger, :chat_id

    def initialize(args)
      parser = MessageParser.new(args.fetch(:message))
      @messenger = args.fetch(:messenger)
      @command = COMMANDS.include?(parser.command) ? parser.command : 'help'
      @params = parser.params
      @author = parser.author
      @chat_id = parser.chat_id
    end

    def process
      if method(command).arity == 0
        self.send command
      else
        self.send command, params
      end
    end

    private

    def today(*params)
      calendar = Calendar.new(date: Date.today, user: author)
      calendar.add_user_to_date
      messenger.send(chat_id: chat_id, text: build_response)
    end

    def today_list
      users = Calendar.users_for_date(Date.today).
        map { |user| "#{user[:first_name]} @#{user[:username]}" }.join("\n")
      messenger.send(chat_id: chat_id, text: list_response(Date.today, users))
    end

    def today_cancel
      calendar = Calendar.new(date: Date.today, user: author)
      result = calendar.delete_user_from_date
      args = result ? {} : {key: 'not_subscribed', date: Date.today}
      messenger.send(chat_id: chat_id, text: build_response(args))
    end

    def help
      messenger.send(chat_id: chat_id, text: build_response)
    end

    def date

    end

    def date_list

    end

    def date_cancel

    end

    def list_response(date, list)
      if list.empty?
        build_response(key: 'nobody', date: date)
      else
        build_response { |r| "#{r}\n#{list}" }
      end
    end

    def build_response(args = {})
      response_key = args.fetch(:key, command)
      response = Initializers::ResponsesLoader.responses[response_key]
      response.gsub!('%first_name%', author.first_name)
      response.gsub!('%date%', args[:date].to_s) if args[:date]

      block_given? ? yield(response) : response
    end
  end
end
