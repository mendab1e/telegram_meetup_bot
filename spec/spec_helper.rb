require 'bundler/setup'
Bundler.setup

require 'telegram_meetup_bot'
require 'timecop'
require File.expand_path('../../lib/telegram_meetup_bot.rb', __FILE__)

RSpec.configure do |config|
end
