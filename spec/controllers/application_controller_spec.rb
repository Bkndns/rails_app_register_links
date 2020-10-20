require 'rails_helper'

require 'net/http'
require 'time'

# require 'rest-client'

RSpec.describe ApplicationController, type: :controller do
	
	
	context 'Проверяем GET ссылку на возможные значения вместо timestamp' do
		
		
		before do
			@timestamp_true = Time.now.to_i
			@status_timestamp_len = "Поле from должно состоять из 10 цифр (timestamp)"
			@status_timestamp_len_alpha = ["Поле from должно быть числом", "Поле from должно состоять из 10 цифр (timestamp)"]
			@status_from_to_empty = ["Поле from не может быть пустым", "Поле from должно быть числом", "Поле from должно состоять из 10 цифр (timestamp)"]
		end

		it "правильный GET запрос к функции. Должен вернуть TRUE" do
			timestamp_from = 1592231777
			begin
				get :visited_domains, :params => { :from => timestamp_from, :to => @timestamp_true }, format: :json
				resp = JSON.parse(response.body)
				expect(resp["status"]).to eq("ok")
				expect(resp).to include("domains")
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end

		end
		
		it "параметры from или to > 10 символов" do
			timestamp_false = 159223177
			begin
				get :visited_domains, :params => { :from => timestamp_false, :to => @timestamp_true }, format: :json
				resp = JSON.parse(response.body)
				expect(resp["status"]["from"].join(" ")).to eq(@status_timestamp_len)
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "Попробуем передать в один из параметров не число? а буквы from или to > 10 символов" do
			timestamp_false = "abirvalgqwe"
			begin
				get :visited_domains, :params => { :from => timestamp_false, :to => @timestamp_true }, format: :json
				resp = JSON.parse(response.body)
				expect(resp["status"]["from"]).to eq(@status_timestamp_len_alpha)
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end
		
		it "параметры 'from' или 'to' пусты" do
			begin
				get :visited_domains, :params => { :from => "", :to => @timestamp_true }, format: :json
				resp = JSON.parse(response.body)
				expect(resp["status"]["from"]).to eq(@status_from_to_empty)
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end
		
	end



	context 'Проверяем POST ссылку на возможные значения, json, links, etc...' do
		
		before do
			
			@timestamp_true = Time.now.to_i
			@status_json_err = "[Error] Произошла ошибка. Передан неправильный JSON. Проверьте синтаксис."
			@status_json_err_links = "[Error] На сервер передан неверный формат JSON. Отсутствует массив links"
			@status_json_err_empty = "[Error] На сервер передан пустой массив links"
		end

		let(:json_add) { 
			{
      	"links": [
					"stackoverflow",
					"www.google.com",
					"https://ya2.ru",
					"https://ya3.ru",
					"example.ru",
					"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor"
      	]
			}
		}
		let(:json_wlinks) { 
			'{
      	"link": [
					"stackoverflow",
					"www.google.com",
					"https://ya2.ru",
					"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor"
      	]
			}' 
		}
		let(:json_empty_s) { 
			{
				"status": "unkn"
			} 
		}
		let(:json_empty) { 
			{
				"links": [],
				"status": "unkn"
			} 
		}
		let(:json_add_fail) { 
			'{
      	"links": [
					"stackoverflow",
					"www.google.com",
					https://ya2.ru
					"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor"
      	]
			}'
		}



		# [post_data_visited_links]

		it "Правильный запрос к функции. Должен вернуть TRUE" do
			begin
				post :visited_links, :params => { :application => json_add }, format: :json
				result = JSON.parse(response.body)
				expect(result).to eq({"status"=>"ok"})
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end
		
		it "Попробуем передать неверный JSON (без массива [links]) и получить ошибку" do
			begin
				post :visited_links, :params => { :application => json_wlinks }, format: :json
				result = JSON.parse(response.body)
				expect(result["status"]).to eq(@status_json_err_links)
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "Попробуем передать неверный JSON (пустой массив [links]) и получить ошибку" do
			begin
				post :visited_links, :params => { :application => json_empty }, format: :json
				result = JSON.parse(response.body)
				expect(result["status"]).to eq(@status_json_err_links)
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "Попробуем передать неверный JSON без массива [links] и получить ошибку" do
			begin
				post :visited_links, :params => { :application => json_empty_s }, format: :json
				result = JSON.parse(response.body)
				expect(result["status"]).to eq(@status_json_err_links)
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end
		
		# [post_data_visited_links]
	end



	context 'GET && POST Requests / Response test' do

		let(:json_add) { 
			{
      "links": [
					"stackoverflow",
					"www.google.com",
					"https://ya2.ru",
					"https://ya3.ru",
					"example.ru",
					"https://stackoverflow2.com/questions/11828270/how-to-exit-the-vim-editor"
      	]
			}
		}

		it "GET запрос к корню / вернёт" do
			begin
				get :index, format: :json
				resp = JSON.parse(response.body)
				expect(resp).to eq({"status" => "Hello, World!"})
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "GET запрос на получение хранимых ссылок - проверка типа возвращаемого значения - JSON" do
			# ?from=1592080286&to=1592173497
			begin
				get :visited_domains, :params => { :from => 1592080286, :to => Time.now.to_i }, format: :json
				resp_content_type = "application/json; charset=utf-8"
				expect(response.content_type).to eq(resp_content_type)
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "GET запрос на получение хранимых ссылок" do
			# ?from=1592080286&to=1592173497
			begin
				get :visited_domains, :params => { :from => 1592080286, :to => Time.now.to_i }, format: :json
				resp_body = JSON.parse(response.body)
				expect(resp_body).to include("domains")
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		it "GET запрос на получение хранимых ссылок - проверим стату код 200" do
			# ?from=1592080286&to=1592173497
			begin
				get :visited_domains, :params => { :from => 1592080286, :to => Time.now.to_i }, format: :json
				status_code = response.code
				expect(status_code.to_i).to eql(200)
			rescue Errno::ECONNREFUSED
				puts "[GET Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

		#####

		it "POST запрос к url_post_links = Добавление ссылок" do
			begin
				post :visited_links, :params => { :application => json_add }, format: :json
				result = JSON.parse(response.body)
				expect(result).to eq({"status"=>"ok"})
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end


		it "POST запрос на проверку кода ответа 200" do
			begin
				post :visited_links, :params => { :application => json_add }, format: :json
				status_code = response.code
				expect(status_code.to_i).to eql(200)
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end


		it "POST запрос на проверку типа ответа JSON" do
			begin
				post :visited_links, :params => { :application => json_add }, format: :json
				resp_content_type = "application/json; charset=utf-8"
				expect(response.content_type).to eq(resp_content_type)
			rescue Errno::ECONNREFUSED
				puts "[POST Response Error]. Connection fail. Failed to open TCP connection. Server is start?"
			end
		end

	end


end
