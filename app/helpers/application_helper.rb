require 'uri'
require 'json'

module ApplicationHelper
  def hello
    p 'Application Helper Hello'
  end

  def render_404
    respond_to do |format|
      format.any { render :json => {:status => '404 Not Found' }, :status => 404  }
    end
  end

  def set_status(str)
    status = str
  end

  def set_status_ok
    set_status("ok")
  end

  def status_is_ok?(status)
    true if status == "ok"
  end
  ###

  def valid_json?(string)
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end

  def get_url_only(dirty_url, _scheme = 'https')
    if dirty_url != false
      url = URI.parse(dirty_url)
      # url = url.host || url.path
      url = url.host.nil? ? false : url.host 
    end 
  end

  def valid_url?(url)
    url_regexp = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    url =~ url_regexp ? true : false
  end

  # Make https://site.ru URL
  # dirty_url is url (www.ya.ru, ya.ru, http://ya.ru)
  def normalize_url(dirty_url, scheme = 'https')
    url = URI.parse(dirty_url)
    url = URI.parse("#{scheme}://#{url}") if url.scheme.nil?
    host = url.host.downcase
    url = url.to_s.downcase
    url = host.start_with?('www.') ? "#{scheme}://#{host[4..-1]}" : url
    url = valid_url?(url) ? url : false # stackowerflow
  end

end