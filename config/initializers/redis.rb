rediscloud_url = Rails.application.credentials.redis[:url]

Sidekiq.configure_server do |config|
  config.redis = { url: rediscloud_url, size: 12,
                   password: Rails.application.credentials.redis[:password] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: rediscloud_url, size: 3,
                   password: Rails.application.credentials.redis[:password] }
end
