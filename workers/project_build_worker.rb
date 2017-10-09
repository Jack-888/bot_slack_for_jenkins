require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './webhooks_slack/slack_sender'
require './jenkins/jenkins_script.rb'
require './db/models.rb'

class ProjectBuildWorker
  include Sidekiq::Worker
  include SlackSender

  def perform(project_name, user_name_slack)
    way_project = search_way_project(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
    text = jenkins_build_job(way_project, project_name)
    send_jenkins_message_to_slack(text)
  end

  private

  def search_way_project(project_name, user_name_slack)
    Project.new.search_way_project(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
  end

  def jenkins_build_job(way_project, project_name)
    JenkinsApi::ProjectJenkins.new.jenkins_build_job(way_project, project_name)
  end

end
