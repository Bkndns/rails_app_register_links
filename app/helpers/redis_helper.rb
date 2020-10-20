module RedisHelper
  
  include ApplicationHelper

  def add_link(link)
    link = get_url_only(normalize_url(link))
    # p link
    if link != false && !link.nil?
      str_for_redis = redis_add_format(link)
    end
  end

  def redis_add_format(url)
    fmt = [timestamp, url]
  end

  def redis_insert(key, val)
    REDIS_CLIENT.zadd(key, val) if val.kind_of?(Array)
  end

  def redis_get_result(key, from, to)
    REDIS_CLIENT.zrangebyscore(key, from, to)
    # domainss
  end

  def timestamp
    Time.now.to_i
  end
  ###

  
end