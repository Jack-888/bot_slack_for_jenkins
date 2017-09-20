require 'slack-ruby-bot'
require 'pry'
require './status_worker.rb'

class JenkinsBot < SlackRubyBot::Bot
  include ServiceSendResult

# 1) Request for project status

  match /^Jean, what about (?<projectname>\w*)/ do |client, data, match|
    StatusWorker.perform_async(match[:projectname], client, data)
  end

end


JenkinsBot.run

