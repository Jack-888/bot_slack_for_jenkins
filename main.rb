require 'slack-ruby-bot'
require 'pry'
require 'chronic'

require './workers/hard_worker.rb'
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
    Worker::StatusWorker.perform_async(project_name, user_name_slack)
  end

########## 2) Request for a project build #######################################
  match /Jean, can you please build (?<project_name>\w*)/ do |client, data, match|
    project_name = match[:project_name]
    user_name_slack = data.user
    Worker::BuildWorker.perform_async(project_name, user_name_slack)
  end


########## 3-4) Reminders about events, task 4 - delete events #########

  match /Jean, can you remind (?<name_user>[^$]+) about (?<notification_text>[^$]+) at (?<reminder_time>[^$]+)/ do |client, data, match|
    if match[:name_user] == 'me'
      name_user_for_reminder = data.user
    else
      name_user_for_reminder = match[:name_user].gsub(/[<>@]/, '') # because slack send "<@U7F98RB2A>"
    end
    user_name_slack = data.user
    reminder_text   = match[:notification_text]
    reminder_time_chronic = Chronic.parse(match[:reminder_time])
    reminder_time = match[:reminder_time]
    Worker::ReminderWorker.perform_async(user_name_slack, name_user_for_reminder, reminder_text, reminder_time_chronic, reminder_time)
  end

# Delete event
# Jean, can you please stop remind me at 10:00 every monday

  match /Jean, can you please stop remind (?<name_user>[^$]+) at (?<reminder_time>[^$]+)/ do |client, data, match|
    name_user_for_reminder = match[:name_user].gsub(/[<>@]/, '')
    user_name_slack = data.user
    reminder_time = match[:reminder_time]
    Worker::DeleteWorker.perform_async(name_user_for_reminder, user_name_slack, reminder_time)
  end

########## 5) Add addresses for monitoring #############################

  match /Jean, can you please watch (?<project_url_monitoring>"<.*?>") it is (?<projects_name>\w*)/ do |client, data, match|
    user_name_slack = data.user
    project_url_monitoring = match[:project_url_monitoring].gsub(/[<>"]/, "")
    project_name = match[:projects_name]
    Worker::MonitoringAddressWorker.perform_async(user_name_slack, project_url_monitoring, project_name)
  end

  match /Add (?<project_address>"<.*?>") it is (?<project_name>\w*) and way (?<project_way>\S*)/ do |client, data, match|
    user_name_slack = data.user
    project_url_jenkins = match[:project_address].gsub(/[<>"]/, "")
    project_url_slack = match[:project_address].gsub(/[<>]/, "")
    project_name = match[:project_name]
    project_way = match[:project_way]
    Project.new.user_add_project_jenkins(user_name_slack, project_url_jenkins, project_url_slack, project_name, project_way)
    client.say(text: "OK", channel: data.channel)
  end

end

JenkinsBot.run




