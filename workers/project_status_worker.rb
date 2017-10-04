require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './webhooks_slack/slack_sender'
require './jenkins/jenkins_script.rb'


class ProjectStatusWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(project_name, client, data)
     way_project = "DevopsTest/job/GradleUnitTest"
     text = JenkinsApi::ProjectJenkins.new.jenkins_status_project(way_project, project_name)

    # text = "ProjectStatusWorker #{project_name}, OK"

    send_jenkins_message_to_slack(text)

  end

end
