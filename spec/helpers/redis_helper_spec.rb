require "rails_helper"

RSpec.describe RedisHelper, :type => :helper do
  
	context 'Проверяем GET ссылку на возможные значения вместо timestamp' do
		
		before do
			@app_object = helper
			@timestamp_true = @app_object.timestamp
			@status_timestamp_len = "[Error] Переданный timestamp в переменную from или to является неверным (10 цифр)"
			@status_from_to_empty = "[Error] Требуется указать переменные from и to"
		end

		it "[add_link(link)] Проверяем результат работы вспомогательной функции" do
			test_link = "https://funbox.ru"
			link_wh = "funbox.ru"
			check = @app_object.add_link(test_link)
			expect(check).to eq([@timestamp_true, link_wh])
		end

		it "[add_link(link)] Проверяем результат работы вспомогательной функции - передадим неверный url. Ожидается nil" do
			test_link = "funbox."
			check = @app_object.add_link(test_link)
			expect(check).to be_nil
		end

		
	end
		
end