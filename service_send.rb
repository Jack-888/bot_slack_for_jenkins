require './workers/status_worker.rb'

require 'net/http'
require 'json'
require 'httparty'

class StatusSlack

  class << self

    def project_status(projectname, client, data)
      StatusWorker.perform_async(projectname, client, data)
    end

    def send_message(text)
      url = 'https://hooks.slack.com/services/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'

      body = { 'text' => text }.to_json
      HTTParty.post(url, body: body)
    end

  end
end

# Slackiq.message('Server 5 is overloaded!', webhook_name: :data_processing)
