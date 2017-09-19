require 'slack-ruby-bot'
require 'pry'
require './workers/status_worker.rb'

class JenkinsBot < SlackRubyBot::Bot

# 1) Request for project status

  match /^Jean, what about (?<projectname>\w*)/ do |client, data, match|
    status = StatusWorker.perform_async(match[:projectname])

    if status == true
      client.say(channel: data.channel, text: "#{match[:projectname]} was built at %date% with status %projectstatus%.")
    else
      client.say(channel: data.channel, text: "#{match[:projectname]} is building now.")
    end
  end

# 2)Request for a project build

  match /Jean, can you please build (?<projectname>\w*)/ do |client, data, match|
    status = false
    
    if status == true
      client.say(channel: data.channel, text: "Ok, build #{match[:projectname]} has started.")
    else
      client.say(channel: data.channel, text: "Sorry, #{match[:projectname]} is already in progress, please wait for result.")
    end
  end

# 3) 

  match /Jean, can you remind me about %notification text% at 5 a.m. tommorow/ do |client, data, match|
    status = false
    
    if status == true
      client.say(channel: data.channel, text: "Ok, build #{match[:projectname]} has started.")
    else
      client.say(channel: data.channel, text: "Sorry, #{match[:projectname]} is already in progress, please wait for result.")
    end
  end



# 4)

# 5)

end

JenkinsBot.run

