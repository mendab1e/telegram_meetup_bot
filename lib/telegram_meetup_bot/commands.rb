require 'telegram_meetup_bot/commands/factory'
require 'telegram_meetup_bot/commands/base'
require 'telegram_meetup_bot/commands/nil_username'
require 'telegram_meetup_bot/commands/cal_command'
require 'telegram_meetup_bot/commands/cancel_command'
require 'telegram_meetup_bot/commands/date_command'
require 'telegram_meetup_bot/commands/help_command'
require 'telegram_meetup_bot/commands/list_command'
require 'telegram_meetup_bot/commands/user_command'

COMMANDS = %w(date list cancel help cal user)
BLACK_LIST = %w(me)
DEFAULT_COMMAND = 'help'
