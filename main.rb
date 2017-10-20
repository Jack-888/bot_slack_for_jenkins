require 'slack-ruby-bot'
require 'pry'

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
# Remind event am, pm
# Jean, can you remind me about %notification text% at 5 a.m. tommorow

  match /Jean, can you remind (?<name_user>[^$]+) about (?<notification_text>[^$]+) at (?<reminder_time>[^$]+)/ do |client, data, match|
    p '========================================='
    if match[:name_user] == 'me'
      name_user_for_reminder = data.user
    else
      name_user_for_reminder = match[:name_user].gsub(/[<>@]/, '') # because slack send "<@U7F98RB2A>"
    end
    p name_user_for_reminder
    p user_name_slack = data.user
    p notification_text = match[:notification_text] #.gsub!(/[^0-9A-Za-z ]/, '')
    p reminder_time = match[:reminder_time]

    p '========================================='
    # p Time.now
    # p reminder_time_Chronic =  Chronic.parse(reminder_time)
    #
    # p seconds = Chronic.parse(reminder_time).to_i - Time.now.to_i
    # p minutes = seconds / 60
    #
    # p times = Time.at(reminder_time_Chronic).utc.strftime("%H:%M:%S") # sec = 236 # seconds => "00:03:56"

    Worker::ReminderWorker.perform_async(name_user_for_reminder, user_name_slack, notification_text, reminder_time)

    # client.say(text: "<@U7F98RB2A>", channel: data.channel) ######################### USER NAME
    p '========================================='

    client.say(text: " Ok, i will remind #{Chronic.parse(reminder_time)}", channel: data.channel)
  end

# Remind event time at every day
# Jean, can you remind %nameofuser% about %notification text% at 5 a.m. tommorow

# match /Jean, can you remind about (?<notification_text>\w*) at (?<time>\w*) at every (?<day>\w*)/ do |client, data, match|
#   name_user = "I"
#   notification_text = match[:notification_text]
#   time = match[:time]
#   time_interval = "err"
#   when_remind = match[:day]
#   Worker::ReminderWorker.perform_async(name_user, notification_text, time, time_interval, when_remind)
# end

# Delete event
# Jean, can you remind about %notification text% at 9:00 at every monday

# match /Jean, can you please (?<stop>\w*) remind me at (?<time>\w*) at every (?<day>\w*)/ do |client, data, match|
#   name_user = match[:stop]
#   notification_text = "arr2"
#   time = match[:time]
#   time_interval = "err"
#   when_remind = match[:day]
#   Worker::ReminderWorker.perform_async(name_user, notification_text, time, time_interval, when_remind)
# end

########## 5) Add addresses for monitoring #############################
#        Jean, can you please watch адрес_сайта it is имя проекта and way путь_проекта, Jean, can you please watch (?<projects_address>"<.*?>") it is (?<projects_name>\w*) and way (?<project_way>\S*)
#   match /Jean, can you please watch (?<projects_address>"<.*?>") it is (?<projects_name>\w*) and way (?<project_way>\S*)/ do |client, data, match|
#     user_name_slack = data.user
#     projects_url_jenkins = match[:projects_address].gsub(/[<>"]/, "")
#     projects_url_slack = match[:projects_address].gsub(/[<>]/, "")
#     projects_name = match[:projects_name]
#     project_way = match[:project_way]
#     Worker::MonitoringAddressWorker.perform_async(user_name_slack, projects_url_jenkins, projects_url_slack, projects_name, project_way)
#     client.say(text: "Ok, i will keep an eye on it.", channel: data.channel)
#   end


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




