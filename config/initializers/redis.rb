uri = "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/0/your-app-cache" || 'redis://localhost:6379/0/your-app-cache'

Rails.application.config.cache_store = :redis_store, uri