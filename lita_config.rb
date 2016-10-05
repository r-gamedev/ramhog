#! /usr/local/bin/ruby -w

# ENV Validation #
%w(irc_username
   irc_password
   irc_channels_csv
   REDIS_URL
   rabbitmq_url)
  .select { |k| !ENV[k] }
  .map { |k| puts "ENV['#{k}'] missing" }
  .map { abort('environment missing') }
##################

# Script Intro #
PROC_ID ||= SecureRandom.uuid
puts 'Hello, world!'
puts "Process ID: #{PROC_ID}"
################

Lita.configure do |config|
  config.robot.name = 'ramhog'
  config.robot.adapter = :irc
  config.adapters.irc.server = 'irc.freenode.net'
  config.adapters.irc.channels = ENV['irc_channels_csv'].split(',')
  config.adapters.irc.user = ENV['irc_username']
  config.adapters.irc.password = ENV['irc_password']
  config.adapters.irc.realname = 'bother lemtzas - bot'
  config.adapters.irc.cinch = lambda do |cinch_config|
    cinch_config.port = 6697
    cinch_config.ssl.use = true
    cinch_config.max_messages = 3
    cinch_config.nicks = [
      'ramhog',
      'ramhog[0]',
      'ramhog[1]',
      'ramhog[2]',
      'ramhog[3]',
      'ramhog[4]',
      'ramhog[5]',
      'ramhog[6]',
      'ramhog[7]',
      'ramhog[8]',
      'ramhog[9]',
      'ramhog[X]']
  end

  config.http.port = 8081
  config.robot.log_level = :info # :debug, :info, :warn, :error, :fatal

  # see https://github.com/litaio/lita-irc
  config.robot.admins = [
    '3f7a19f6-5507-4cbc-b6ea-f192ee0dffee', # lemtzas, freenode
    'lemtzas',
    'sn0wmonster'
  ]

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.
  # config.handlers.some_handler.some_config_key = 'value'
end
