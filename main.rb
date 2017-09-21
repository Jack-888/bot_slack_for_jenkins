require 'slack-ruby-bot'
require 'pry'
require './service_send.rb'

class JenkinsBot < SlackRubyBot::Bot

# 1) Request for project status

  match /^Jean, what about (?<projectname>\w*)/ do |client, data, match|
    StatusSlack.project_status(match[:projectname], client, data)
  end

end

JenkinsBot.run

