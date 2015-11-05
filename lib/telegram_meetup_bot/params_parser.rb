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
      when /\A[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2}\Z/
        "%d.%m.%y"
      when /\A[0-9]{1,2}\.[0-9]{1,2}\Z/
        "%d.%m"
      when /\A[0-9]{1,2}\Z/
        "%d"
      end

      Date.strptime(arg, format) rescue nil
    end

    def parse_time
      if arg =~ /\A[0-2][0-9]:[0-5][0-9]\Z/
        Time.parse(arg).strftime('%R') rescue nil
      end
    end

    def parse_month
      month = arg.to_i

      if month >= 1 && month <= 12
        month
      end
    end
  end
end
