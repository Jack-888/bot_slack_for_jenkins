require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'

require './webhooks_slack/slack_sender'
require './jenkins/jenkins_script.rb'
require './db/models.rb'

module Worker

  class StatusWorker
    include Sidekiq::Worker
    include SlackSender

    def perform(project_name, user_name_slack)
      way_project = search_way_project_in_db(project_name, user_name_slack)
      message= jenkins_status_project(way_project, project_name)
      send_jenkins_message_to_slack(message)
    end

    private

    def search_way_project_in_db(project_name, user_name_slack)
      Project.new.search_way_project(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
    end

    def jenkins_status_project(way_project, project_name)
      ProjectJenkins.new.jenkins_status_project(way_project, project_name)
    end
  end

  class BuildWorker
    include Sidekiq::Worker
    include SlackSender

    def perform(project_name, user_name_slack)
      way_project = search_way_project_in_db(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
      text = jenkins_build_job(way_project, project_name)
      send_jenkins_message_to_slack(text)
    end

    private

    def search_way_project_in_db(project_name, user_name_slack)
      Project.new.search_way_project(project_name, user_name_slack) # way_project = "DevopsTest/job/GradleUnitTest" in BD
    end

    def jenkins_build_job(way_project, project_name)
      ProjectJenkins.new.jenkins_build_job(way_project, project_name)
    end
  end

  class MonitoringAddressWorker
    include Sidekiq::Worker
    include SlackSender

    def perform(user_name_slack, projects_url_jenkins, projects_url_slack, projects_name, project_way)
      Project.new.user_add_project(user_name_slack, projects_url_jenkins, projects_url_slack, projects_name, project_way)
      text = "Ok, i will keep an eye on it #{projects_name}"
      send_jenkins_message_to_slack(text)
    end
  end

  class RemindEventWorker
    include Sidekiq::Worker
    include SlackSender

    def perform(name_user, notification_text, time, time_interval, when_remind)
      text = "Ok, I will remind you. Name user = #{name_user}, notification text = #{notification_text}, time = #{time}, #{time_interval}, when = #{when_remind}"
      send_reminder_message_to_slack(text)
    end
  end
end