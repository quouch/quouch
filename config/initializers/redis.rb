rediscloud_url = ENV.fetch('REDISCLOUD_URL', nil)

Sidekiq.configure_server do |config|
  config.redis = { url: rediscloud_url, size: 12 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: rediscloud_url, size: 3 }
end