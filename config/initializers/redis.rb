rediscloud_url = Rails.application.credentials.dig(:redis, :url)

Sidekiq.configure_server do |config|
  config.redis = { url: rediscloud_url, size: 12,
                   password: Rails.application.credentials.dig(:redis, :password) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: rediscloud_url, size: 3,
                   password: Rails.application.credentials.dig(:redis, :password) }
end
