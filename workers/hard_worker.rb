require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'
require 'httparty'

require 'rufus-scheduler'
require 'chronic'

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

    def perform(user_name_slack, project_url_monitoring, project_name)
      Project.new.user_add_project_monitoring(user_name_slack, project_url_monitoring, project_name)
      project = Project.new.get_project(user_name_slack, project_name)
      project_url_monitoring = project.projects_url_monitoring # IN db "https://example.com/posts/rails-eto-prosto-ruby"
      project_name = project.projects_name # IN db OnlineShopJSFinal
      project_way = project.project_way # IN db DevopsTest/job/GradleUnitTest
      monitoring(project_url_monitoring, project_way,  project_name)
    end

    private

    def monitoring(project_url_monitoring, project_way, project_name )
      status = get_status(project_url_monitoring)
      if status.nil?
        send_jenkins_message_to_slack('Maybe entered your site address incorrectly')
      else
        send_jenkins_message_to_slack("Ok, i will keep an eye on it #{project_name}")
        while [200, 502].include?(status)
          sleep *60 # every one minute
          p status = get_status(project_url_monitoring)
        end
        status_jenkins = ProjectJenkins.new.monitoring_status(project_way)
        send_jenkins_message_to_slack("I can`t reach #{project_url_monitoring}, but it`s not building, maybe i need to rebuild it?")
      end
    end

    def get_status(project_url_monitoring)
      HTTParty.get(project_url_monitoring).code
    rescue
      nil
    end

  end

  class ReminderWorker
    include Sidekiq::Worker
    include SlackSender

    def perform(name_user_for_reminder, user_name_slack, notification_text, reminder_time)

      reminder_time_chronic =  chronic_parse(reminder_time)

      self.jid
      reminder_time_Chronic = Chronic.parse(reminder_time)

      scheduler = Rufus::Scheduler.new

      scheduler.at reminder_time_Chronic do
        send_jenkins_message_to_slack(notification_text)
      end

      scheduler.join

      # send_jenkins_message_to_slack(message)

      # text = "Ok, I will remind you. Name user = #{name_user}, notification text = #{notification_text}, time = #{time}, #{time_interval}, when = #{when_remind}"
      # send_reminder_message_to_slack(text)


    end

    private

    def chronic_parse(reminder_time)
      Chronic.parse(reminder_time)
    end

  end
end































