require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './slack_sender.rb'

class ProjectBuildWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(projectname, client, data)

    text = "ProjectBuildWorker #{projectname}, OK"

    send_message_to_slack(text)

  end

end
