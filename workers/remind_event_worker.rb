require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './webhooks_slack/slack_sender.rb'

class RemindEventWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(name_user, notification_text, time, time_interval, when_remind)

    text = "Ok, I will remind you. Name user = #{name_user}, notification text = #{notification_text}, time = #{time}, #{time_interval}, when = #{when_remind}"

    send_reminder_message_to_slack(text)

  end

end
