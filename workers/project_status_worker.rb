require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require 'slackiq'

require './webhooks_slack/slack_sender'
require './jenkins/jenkins_script.rb'
require './db/models.rb'



Slackiq.configure( send_slack: 'https://hooks.slack.com/services/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')



class ProjectStatusWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(project_name, user_name_slack)
   way_project = search_way_project(project_name, user_name_slack)

   text = jenkins_status_project(way_project, project_name)

   Slackiq.message(text, webhook_name: :send_slack)

   # send_jenkins_message_to_slack(text)

  end

  private

  def search_way_project(project_name, user_name_slack)
    Project.new.search_way_project(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
  end

  def jenkins_status_project(way_project, project_name)
    JenkinsApi::ProjectJenkins.new.jenkins_status_project(way_project, project_name)
  end

end
