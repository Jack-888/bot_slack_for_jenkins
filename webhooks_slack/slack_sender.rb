# require 'net/http'
# require 'json'
# require 'httparty'

require 'slack-notifier'

module SlackSender

  def send_jenkins_message_to_slack(message, user_channel)
    jenkins_web_hooks = 'https://hooks.slack.com/services/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'
# # binding.pry
#     body = { 'text' => message }.to_json
#     HTTParty.post(jenkins_web_hooks, body: body)

    notifier = Slack::Notifier.new jenkins_web_hooks
    # notifier.ping "Hello World"
    notifier.ping message, channel: "#chat_with_a_bot"
  end




  # def send_reminder_message_to_slack(message)
  #   reminder_web_hooks = 'https://hooks.slack.com/services/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'
  #
  #   body = { 'text' => message }.to_json
  #   HTTParty.post(reminder_web_hooks, body: body)
  # end

end


