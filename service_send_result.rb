require 'slack-ruby-bot'

module ServiceSendResult

  def send_project_status(projectname, client, data)
    p '==========================================================='
    p 'ServiceSendResult'
    p projectname
    p client
    p data
    p '==========================================================='
    client.say(channel: data.channel, text: "#{projectname} is building now.")

  end
end
