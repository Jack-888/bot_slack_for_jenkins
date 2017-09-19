# Sidekiq.configure_server do |config|
#   config.redis = { db: 1 }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { db: 1 }
# end

class StatusWorker
  include Sidekiq::Worker

  def perform(projectname)
    return true
  end
end
