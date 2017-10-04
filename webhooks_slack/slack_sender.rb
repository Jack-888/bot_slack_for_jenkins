require 'net/http'
require 'json'
require 'httparty'

module SlackSender

  def send_jenkins_message_to_slack(message)
    jenkins_web_hooks = 'https://hooks.slack.com/services/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'

    body = { 'text' => message }.to_json
    HTTParty.post(jenkins_web_hooks, body: body)
  end

  def send_reminder_message_to_slack(message)
    reminder_web_hooks = 'https://hooks.slack.com/services/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'

    body = { 'text' => message }.to_json
    HTTParty.post(reminder_web_hooks, body: body)
  end

end


