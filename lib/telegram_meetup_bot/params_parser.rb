require 'date'
require 'time'

module TelegramMeetupBot
  class ParamsParser
    attr_reader :arg

    def initialize(arg)
      @arg = arg
    end

    def parse_date
      format = case arg
      when /^[0-9]{,2}\.[0-9]{,2}\.[0-9][0-9]$/
        "%d.%m.%y"
      when /^[0-9]{,2}\.[0-9]{,2}$/
        "%d.%m"
      when /^[0-9]{,2}$/
        "%d"
      end

      Date.strptime(arg, format) rescue nil
    end

    def parse_time
      Time.parse(arg).strftime('%R') rescue nil
    end

    def parse_month
      month = arg.to_i

      if month >= 1 && month <= 12
        month
      end
    end
  end
end
