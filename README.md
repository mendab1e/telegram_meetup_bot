# TelegramMeetupBot

[![Build Status](https://travis-ci.org/mendab1e/telegram_meetup_bot.svg)](https://travis-ci.org/mendab1e/telegram_meetup_bot)

Telegram bot for meetups organisation. It suits really well for small communities, where people want to attend a place together, but not on regular basis.

![chat example](https://cloud.githubusercontent.com/assets/854386/9875843/23b37e8a-5bba-11e5-8c6f-c4777c8a1eff.png)

## Installation

Install redis: http://redis.io/

Install the gem:

    $ gem install telegram_meetup_bot

## Usage

Register your bot and [obtain a token](https://core.telegram.org/bots#botfather)

Run redis server:

    $ redis-server

Generate sample configurations:

    $ telegram_meetup_bot --generate

You should specify your bot_token and bot_name in ```~/.telegram_meetup_bot/config.yml```.
```
bot_token: 'insert your token here'
bot_name: 'meetup_dev_bot'
redis_host: 'localhost'
redis_port: '6379'
redis_key: 'meetup_bot'
```
If you use more than one bot per redis server, use different redis_keys for each of them.

Also you could change sample responses in ```~/.telegram_meetup_bot/responses.yml```. It uses templates ```%first_name%``` and ```%date%``` to display actual name and date in messages.

Run your bot:

    $ telegram_meetup_bot

## Contributing

1. Fork it ( https://github.com/[my-github-username]/telegram_meetup_bot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
