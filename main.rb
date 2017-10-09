require 'slack-ruby-bot'
require 'pry'

require './workers/project_status_worker.rb'
require './workers/project_build_worker.rb'
require './workers/remind_event_worker.rb'
require './workers/monitoring_address_worker.rb'
require './db/models.rb'


class JenkinsBot < SlackRubyBot::Bot

  command 'sign up' do |client, data,|
    user_name_slack = data.user
    channel_name_slack = data.channel
    status = User.new.db_check_user_sign_up(user_name_slack)
    if status == "false" # If User not registrarion
      status = User.new.sign_up(user_name_slack, channel_name_slack)
      client.say(text: "CONGRATULATIONS <@#{status}>, you are registered", channel: data.channel)
    else
      client.say(text: "YOU ARE ALREADY REGISTERED", channel: data.channel)
    end
  end

########## 1) Request for project status #######################################

  match /Jean, what about (?<project_name>\w*)/ do |client, data, match|
    project_name = match[:project_name]
    user_name_slack = data.user
    user_channel = data.channel
    # binding.pry
    ProjectStatusWorker.perform_async(project_name, user_name_slack, user_channel)
  end

########## 2) Request for a project build #######################################
  match /Jean, can you please build (?<project_name>\w*)/ do |client, data, match|
    project_name = match[:project_name]
    user_name_slack = data.user
    ProjectBuildWorker.perform_async(project_name, user_name_slack)
  end


########## 3-4) Reminders about events, task 4 - delete events #########
# Remind event am, pm
  match /Jean, can you remind (?<me>\w*) about (?<notification_text>\w*) at (?<time>\w*) (?<time_interval>\w*) (?<when_remind>\w*)/ do |client, data, match|
    name_user = match[:me]
    notification_text = match[:notification_text]
    time = match[:time]
    time_interval = match[:time_interval]
    when_remind = match[:when_remind]
    RemindEventWorker.perform_async(name_user, notification_text, time, time_interval, when_remind)
  end

# Remind event time at every day
  match /Jean, can you remind about (?<notification_text>\w*) at (?<time>\w*) at every (?<day>\w*)/ do |client, data, match|
    name_user = "I"
    notification_text = match[:notification_text]
    time = match[:time]
    time_interval = "err"
    when_remind = match[:day]
    RemindEventWorker.perform_async(name_user, notification_text, time, time_interval, when_remind)
  end

# Delete event
  match /Jean, can you please (?<stop>\w*) remind me at (?<time>\w*) at every (?<day>\w*)/ do |client, data, match|
    # binding.pry
    name_user = match[:stop]
    notification_text = "arr2"
    time = match[:time]
    time_interval = "err"
    when_remind = match[:day]
    # binding.pry
    RemindEventWorker.perform_async(name_user, notification_text, time, time_interval, when_remind)
  end

########## 5) Add addresses for monitoring #############################
#        Jean, can you please watch адрес_сайта it is имя проекта and way путь_проекта
  match /Jean, can you please watch (?<projects_address>"<.*?>") it is (?<projects_name>\w*) and way (?<project_way>\S*)/ do |client, data, match|
    user_name_slack = data.user
    projects_url_jenkins = match[:projects_address].gsub(/[<>"]/, "")
    projects_url_slack = match[:projects_address].gsub(/[<>]/, "")
    projects_name = match[:projects_name]
    project_way = match[:project_way]
    Project.new.user_add_project(user_name_slack, projects_url_jenkins, projects_url_slack, projects_name, project_way)
    client.say(text: "Ok, i will keep an eye on it (#{projects_url_jenkins})" , channel: data.channel)

    # MonitoringAddressWorker.perform_async(user_name, projects_address, projects_name)
  end


#   match /a/ do |client, data, match|
#     user_name_slack = 'U74GJ917V'
#     projects_name = 'GradleUnitTest'
#     p '============================================================================================================================='
#     p user = User.where(user_name_slack: user_name_slack).first
#     p aa = user.projects.find_by(projects_name: projects_name)["project_way"]
#     p '============================================================================================================================='
#
# binding.pry
#     client.say(text: "Ok)" , channel: data.channel)
#   end





end

JenkinsBot.run




