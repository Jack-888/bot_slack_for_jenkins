require 'slack-notifier'

module SlackSender

  def send_jenkins_message_to_slack(message)
    jenkins_web_hooks = 'https://hooks.slack.com/services/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'
    send_to_slack(message, jenkins_web_hooks)
  end

  def send_reminder_message_to_slack(message)
    reminder_web_hooks = 'https://hooks.slack.com/services/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'
    send_to_slack(message, reminder_web_hooks)
  end

  private

  def send_to_slack (message, web_hooks)
    notifier = Slack::Notifier.new web_hooks
    notifier.ping message, channel: "#general" # "#general" or "#random"  or other channels you create, "#chat_with_a_bot"
  end


end