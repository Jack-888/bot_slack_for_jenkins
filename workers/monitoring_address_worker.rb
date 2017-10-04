require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './webhooks_slack/slack_sender'
require './db/models.rb'

class MonitoringAddressWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(user_name, projects_address, projects_name)

    # binding.pry

    user = User.create!(user_name: user_name)
    user.projects.create!(projects_name: projects_name, projects_address: projects_address)

    text = "OK"
    send_message_to_slack(text)

  end

end
