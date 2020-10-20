REDIS_CLIENT = Redis.new(
  host: Rails.configuration.redis['host'], 
  port: Rails.configuration.redis['port'], 
  # db: Rails.configuration.redis['db']
)