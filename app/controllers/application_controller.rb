class ApplicationController < ActionController::Base

	protect_from_forgery unless: -> { request.format.json? }
  
  before_action :validate_params, only: [ :visited_domains ]
  
  def render_404
    respond_to do |format|
      format.any { render :json => {:status => "404 Not Found"}, :status => 404 }
    end
  end

  def render_500
    respond_to do |format|
      format.any { render :json => {:status => "500 Internal Server Error"}, :status => 500 }
    end
  end

  def index
    respond_to do |format|
      format.json { render :json => { status: "Hello, World!" } }
    end
  end

	# 
  def visited_links
    result = post_data_json_validator(params[:application])
    if helpers.status_is_ok? result[:status]
      params[:application][:links].each { |url| helpers.redis_insert(Rails.configuration.redis['domains_key'], helpers.add_link(url)) }
      # puts helpers.timestamp
    end

    respond_to do |format|
      format.json { render :json => { status: result[:status] } }
    end
  end

	#
	def visited_domains
		time_from, time_to = params[:from], params[:to]

    result_from_redis = helpers.redis_get_result(Rails.configuration.redis['domains_key'], time_from, time_to)
            
    # p '##### REDIS #####'
    # p result_from_redis

    respond_to do |format|
      format.json { render :json => {  domains: result_from_redis, status: helpers.set_status_ok } }
    end
  end
	
	
	private

  def post_data_json_validator(post_params)
    
    results = {}
    n_post_data = post_params.to_json

    valid_json_check = helpers.valid_json? n_post_data

    if valid_json_check

      object = JSON.parse n_post_data

      if object['links']

        if !object['links'].empty?
          results[:status] = helpers.set_status_ok
        else
          status = helpers.set_status("[Error] На сервер передан пустой массив links")
          results[:status] = status
        end

      else
        status = helpers.set_status("[Error] На сервер передан неверный формат JSON. Отсутствует массив links")
        results[:status] = status
      end

    else
      status = helpers.set_status("[Error] Произошла ошибка. Передан неправильный JSON. Проверьте синтаксис.0 #{post_params}")
      results[:status] = status
    end

    results

	end
	
  def validate_params
    valider = FromtoValidator.new(params)
    if !valider.valid?
      return respond_to do |format|
        format.json { render :json => { status: valider.errors } }
      end
    end
  end

end
