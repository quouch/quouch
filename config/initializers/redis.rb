rediscloud_url = ENV.fetch('REDISCLOUD_URL', nil)

Sidekiq.configure_server do |config|
  config.redis = { url: rediscloud_url, size: 12,
                   protocol: 2 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: rediscloud_url, size: 3,
                   protocol: 2 }
end
