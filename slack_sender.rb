require 'net/http'
require 'json'
require 'httparty'

module SlackSender

  def send_message_to_slack(message)
    url = 'https://hooks.slack.com/services/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'

    body = { 'text' => message }.to_json
    HTTParty.post(url, body: body)
  end

end


