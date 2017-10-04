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
      client.say(text: "Congratulations <@#{status}>, you are registered", channel: data.channel)
    else
      client.say(text: "Sorry <@#{data.user}>, you are already registered!!!", channel: data.channel)
    end
  end

  # 1) Request for project status

  match /Jean, what about (?<project_name>\w*)/ do |client, data, match|
    ProjectStatusWorker.perform_async(match[:project_name], client, data)
    # binding.pry
  end

  # 2) Request for a project build

  match /Jean, can you please build (?<project_name>\w*)/ do |client, data, match|
    ProjectBuildWorker.perform_async(match[:project_name], client, data, main)
  end

  # 3-4) task 3 - reminders about events, task 4 - delete events

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

  # 5) task 5 - add addresses for monitoring
  #        Jean, can you please watch адрес_сайта it is имя проекта
  # match /Jean, can you please watch (?<projects_address>\w*) it is (?<projects_name>\w*)/ do |client, data, match|
  #   # binding.pry
  #   user_name = data.user
  #   projects_address = match[:projects_address]
  #   projects_name = match[:projects_name]
  #   # binding.pry
  #
  #   MonitoringAddressWorker.perform_async(user_name, projects_address, projects_name)
  # end

  match /Jean, can you please watch (?<projects_address>"<.*?>") it is (?<projects_name>\w*)/ do |client, data, match|
    # p .gsub("subString", ""
    # binding.pry

    # p projects_address = match[:projects_address].gsub(/[<>"]/, "")

    client.say(text: "OK #{atch[:projects_address]}, #{match[:projects_name]} " , channel: data.channel)
    # binding.pry
  end


end

JenkinsBot.run

