require 'net/http'
require 'uri'
require 'time'
require 'json'

# Файл для большей автоматизации и простого запуска

namespace :app do
	
	# Можно прописать в default
	desc "1 - Install all dependencies (Bundler)"
	task :binstall do
		system("bundle install")
	end

	# Можно было запустить сервер цепочкой после установки зависимостей. Но нет
	desc "2 - Start Rails Server"
	task :bserver_start do
		system("rails s")
	end

	desc "3 - Test Request to Server"
	task :bserver_test_req do
		url = "http://localhost:3000"
  	uri = URI.parse(url)
  	response = Net::HTTP.get_response(uri)
		content = response.body
		p JSON.parse(content)
	end

	desc "4 - Insert Test data to Rack Server"
	task :dinsert_data do
		# require 'rest-client'
		url_post_links = "http://localhost:3000/visited_links"
		json_add = '{
      "links": [
				"funbox.ru",
				"www.google.com",
				"https://ya.ru",
				"https://ya.ru?q=123",
				"funbox.ru",
				"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor"
      ]
		}' 
		begin
			# response = RestClient.post url_post_links, json_add, {content_type: :json, accept: :json}
			# result = JSON.parse(response.body.force_encoding("UTF-8"))
			system("curl -v -H 'Content-type: application/json' -X POST -d '{ \"links\": [\"https://ya.ru\", \"https://ya3.ru?q=123\", \"funbox.ru\", \"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor\"] }' #{url_post_links}")
		rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
		# rescue RestClient::InternalServerError
		# 		puts "[POST Response Error]. 500 Internal Server Error. Серверная ошибка, возможно проблемы с базой данных Redis."
		end
	end

	desc "5 - Get data"
	task get_data: [:timestamp] do
		# require 'rest-client'
		url_get_links = "http://localhost:3000/visited_domains?from=1592080286&to=#{@timestamp}"
		uri = URI(url_get_links)
		begin
			# resp = RestClient.get url_get_links, {params: {'from': 1592080286, 'to' => @timestamp }}
			resp = Net::HTTP.get(uri)
			resp_body = JSON.parse(resp)
			puts JSON.pretty_generate(resp_body)
		rescue Errno::ECONNREFUSED
			puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
		end
	end

	task :timestamp do
		@timestamp = Time.now.to_i
	end

	desc "6 - Print curl GET request + timestamp now (for copy and paste in console)"
	task print_get_curl: [:timestamp] do
		puts "curl 'http://localhost:3000/visited_domains?from=1592080286&to=#{@timestamp}'"
	end

	desc "7 - Print curl POST request (for copy and paste in console)"
	task print_post_curl: [:timestamp] do
		puts "curl -v -H 'Content-type: application/json' -X POST -d '{ \"links\": [\"https://ya2.ru\", \"https://ya3.ru?q=123\", \"funbox.ru\", \"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor\"] }' http://localhost:3000/visited_links"
	end

	desc "8 - Run all RSpec Tests"
	task :run_rspecs do
		puts "[run rspec application_helper_spec...]"
		system("rspec ./spec/helpers/application_helper_spec.rb")
		puts "[run rspec redis_helper_spec...]"
		system("rspec ./spec/helpers/redis_helper_spec.rb")
		# Можно было цепочкой запустить
		puts "[run rspec app...]"
		system("rspec ./spec/controllers/application_controller_spec.rb")
	end

end