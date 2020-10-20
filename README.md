Ruby on Rails web-приложение, для простого учета посещенных (неважно, как, кем и когда) ссылок. Приложение должно удовлетворять следующим требованиям. Приложение предоставляет два HTTP ресурса. 
*POST /visited_links* и *GET /visited_domains?from=1545221231&to=1545217638*

# Установка
Процесс установки и запуска достаточно прост.
На компьютере должен быть установлен и запущен **Redis**

*Изначально планировалось залить проект на Heroku. В итоге, все манипуляции будем производить через Rake*

Устанавливаем **Rake** и **Bundler** если они еще не установлены

```
sudo gem install rake && sudo gem install bundler
```

Клонируем этот репозиторий

```
git clone https://github.com/adam-p/markdown-here.wiki.git
```

После клонирования, переходим в папку с проектом и вводим команду

```
rails -T
```

Эта команда выводит список доступных команд

```
rails app:binstall          # 1 - Install all dependencies (Bundler)
rails app:bserver_start     # 2 - Start Rack Server
rails app:bserver_test_req  # 3 - Test Request to Rack Server
rails app:dinsert_data      # 4 - Insert Test data to Rack Server
rails app:get_data          # 5 - Get data
rails app:print_get_curl    # 6 - Print curl GET request + timestamp now (for copy and paste in cons...
rails app:print_post_curl   # 7 - Print curl POST request (for copy and paste in console)
rails app:run_rspecs        # 8 - Run all RSpec Tests
```

Рекомендуется запускать команды по порядку.

Команда | Описание 
--- | ---
**rails app:binstall** | автоматически установит все зависимости которые прописаны в проекте
**rails app:bserver_start** | запускает Rack сервер для обработки HTTP запросов.
**rails app:bserver_test_req** | позволит быстро протестировать работоспособность толькочто созданного сервера
**rails app:dinsert_data** | Добавляет тестовые данные в Redis
**rails app:get_data** | Выводит на экран то, что храниться в Redis (последние добавленные даннык)
**rails app:print_get_curl** | Выведет в консоль curl команду для самостоятельного запуска GET запроса к серверу, достаточно просто скопировать команду и запустить.
**rails app:print_post_curl** | Выведет в консоль curl команду для самостоятельного запуска POST запроса к серверу, достаточно просто скопировать команду и запустить.
**rails app:run_rspecs** | запустит и выведет результат тестирования всех тестов фреймворка RSpec

# Ручной запуск и проверка
Клонируем репозиторий
Устанавливаем зависимости
```
bundle install
```
Запускаем rails сервер
```
rails s
```
По умолчанию сервер запускается на порту 3000. Заходим и проверяем его работоспособность (браузер или curl в консоли)
```
curl http://localhost:3000
```
В ответ должны получить:
```
{"status"=>"Hello, World!"}
```
Если увидели такую надпись - поздравляю сервер запущен и работает.
Теперь проверим наши два HTTP ресурса. Чтобы данные отобразились, их нужно добавить. Скрипт использует **Redis** в качестве хранилища данных, поэтому он должен быть установлен и запущен на стандартном порте. Самое время сделать запрос на добавление тестовых данных:
```
curl -v -H 'Content-type: application/json' -X POST -d '{ "links": ["https://ya.ru", "https://ya.ru?q=123", "funbox.ru", "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"] }' http://localhost:3000/visited_links
```
В ответ на этот запрос мы должны увидеть следующее
```
{"status"=>"ok"}
```
Теперь проверим, что же мы добавили выполнив GET запрос который принимает два параметра *from* - timestamp от временной метки и *to* - timestamp до временной метки. Пример запроса:
```
http://localhost:3000/visited_domains?from=1592080286&to=1592353724
```
В ответ мы должны увидеть следующее:
```
{
  "domains": [
    "di.fm",
    "radiorecord.ru",
    "yandex.ru",
    "example.ru",
    "funbox.ru",
    "google.com",
    "stackoverflow.com",
    "ya.ru"
  ],
  "status": "ok"
}
```
Поздравляю, наше Rails web-приложение работает.

*На этом всё.*
*Возможно, стоило всё это делать в одном Docker контейнере и поставлять сам контейнер...*