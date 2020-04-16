# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram_meetup_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "telegram_meetup_bot"
  spec.version       = TelegramMeetupBot::VERSION
  spec.authors       = ["Timur Yanberdin"]
  spec.email         = ["yanberdint@gmail.com"]
  spec.summary       = "Telegram bot for meetups organisation"
  spec.homepage      = "https://github.com/mendab1e/telegram_meetup_bot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = "telegram_meetup_bot"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "timecop"

  spec.add_dependency 'redis'
  spec.add_dependency 'telegram-bot-ruby', "~> 0.5.2"
end
