require 'slack-ruby-bot'
require 'sidekiq'
require 'pry'
require './service_send.rb'

class StatusWorker
  include Sidekiq::Worker

  def perform(projectname, client, data)
    p '============================================='
    p 'StatusWorker'
    puts client
    puts projectname
    puts data
    text = "Клієнт #{client}, його проект #{projectname}"
    StatusSlack.send_message(text)

  end
end
