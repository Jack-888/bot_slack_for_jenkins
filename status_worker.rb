require 'sidekiq'
require 'pry'
require './service_send_result.rb'

class StatusWorker
  include Sidekiq::Worker

  def perform(projectname, client, data)

    p '============================================='
    p 'StatusWorker'
    puts client
    puts projectname
    binding.pry
    puts data

    ServiceSendResult.new.send_project_status(projectname)

  end
end
