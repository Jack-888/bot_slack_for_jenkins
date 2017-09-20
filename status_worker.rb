require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'
require './service_send_result.rb'

class StatusWorker
  include Sidekiq::Worker
  include ServiceSendResult

  def perform(projectname, client, data)

    p '============================================='
    p 'StatusWorker'
    puts client
    puts projectname
    puts data
    send_project_status(projectname, client, data)
  end
end
