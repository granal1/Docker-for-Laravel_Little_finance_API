# Docker for "Application for working with user balances (PHP / Laravel)"

Docker использует Nginx, PHP-FPM, PostgreSQL, Composer, Adminer и Laravel.  
Непосредственно эта сборка создана для работы с приложением из репозитория [https://github.com/granal1/Laravel_Little_finance_API](https://github.com/granal1/Laravel_Little_finance_API)  

|- **[Системные требования](#-Системные-требования)**  
|- **[Настройка и запуск](#-Настройка-и-запуск)**   
|- **[Тестирование приложения](#-Тестирование-приложения)**  
|- **[Документация приложения](#-Документация-приложения)**  

## Системные требования

Проверено на ALT Workstation K 11.1 (Nemorosa) x86_64.  
Для использования требуется `docker`, `docker-compose`, в данном случае `docker compose`.  
Для удобства использования нужна утилита автоматизации сборки `make`.

## Настройка и запуск

1. Загрузка из гит репозитория `git clone https://github.com/granal1/Docker-for-Laravel_Little_finance_API.git project`  
2. При необходимости перенесите проект в требуемую директорию.  
3. Изменение настроек доступа к БД в части имени пользователя, пароля и названия базы данных можно выполнить отредактировав .env  
4. Сборка контейнеров выполняется командой `make build-dev` (`docker compose build`)   
5. <u>ВАЖНО! Для работы контейнера необходимо, чтобы порты 80, 443, 4352, 8000, 9003, 5432 были свободны. Это может потребовать остановки запущенных сервисов</u>   
6. Установка приложения - `make app-install` (`mkdir -m 777 html && git clone https://github.com/granal1/Laravel_Little_finance_API.git html`)  
7. В директории html создать .env по примеру .env.example. Внести в .env настройки работы с БД из .env, находящегося в корне проекта.  
8. Обновление указанных в composer.json библиотек - `make composer-update` (`docker compose run --rm php composer update`)  
9. Сгенерировать ключ безопасности - `make generate-app-key` (`docker compose run --rm php php artisan key:generate`)  
10. Команда запуска контейнера - `make start-dev` (`docker compose up -d`)  
11. Создание рабочих таблиц в БД - `make database-migrate` (`docker compose run --rm php php artisan migrate`)   
12. Добавление в БД первичных данных (10 пользователей) - `make demo-seed` (`docker compose run --rm php php artisan db:seed`)  
13. Очистить кеш можно командой - `make app-cache-clear`  
14. Сформировать (обновить) интерактивную документацию (требуется предварительная очистка кеш) - `app-generate-doc` (`docker compose run --rm php php artisan scribe:generate`)   
15. Страница проекта http://your-domain   
16. Страница adminer: http://your-domain:4352   
17. Страница интерактивной документации http://your-domain/docs   

## Тестирование приложения

Работа приложения может быть проверена выполнением тестов. В общей сложности приложение содержит 37 тестов. Тестами охвачены все основные методы.  
Для проведения тестов необходимо обновить кеш - `make app-cache`  
Тесты могут выводить краткие результаты выполнения в консоли - `make app-test` (`docker compose run --rm php vendor/bin/phpunit --coverage-text`), или и с формированием подробного html отчета - `make app-test-to-html` (`docker compose run --rm php vendor/bin/phpunit --coverage-html coverage-report`).  
Подробный отчет сохраняется в директории html. 

- - -
## Документация приложения

Приведенная ниже документация является копией, приведенной в README.md самого приложения.

# Laravel Little finance API

## Info

Application for working with user balances (PHP / Laravel)

- - -
## Paths

### GET `/api/balance/{user_id}`

#### Summary

Show the bank account balance.

#### Parameters

- **user_id**: The unique identifier of the user (required)

#### Responses

- **200 OK**

  ```
  {
     "user_id": 1,
     "balance": 1500.5
  }
  ```
- **404 Not Found** Possible errors:

  * User not found
  * Bank account not found
  * Wrong endpoint

    ```
    {
      "error": "User not found",
      "message": "User not found",
      "user_id": 123 // Рresent depending on the error
    }
    ```
- - -
### POST `/api/deposit`

#### Summary

Top up a bank account.

#### Requests

- **user_id**: Unique identifier of the user (required)
- **amount**: Amount to deposit (required). Should be positive.
- **comment**: Optional comment about the transaction.

#### Responses

- **200 OK**

  ```
  {
    "user_id": 1,
    "amount": 1000.0,
    "comment": "Salary payment",
    "balance": 2500.5
  }
  ```
  
- **404 Not Found** Possible reasons:
  * User not found
  * Incorrect resource

    ```
    {
      "error": "User not found",
      "message": "User not found",
      "user_id": 123 // Рresent depending on the error
    }
    ```

- **422 Unprocessable Entity** Validation errors:

  ```
  {
    "message": "The user id field must be at least 1. (and 1 more error)",
    "errors": {
      "user_id": ["The user id field must be at least 1."],
      "amount": ["Amount must be at least 0.01"]
    }
  }
  ```
  
- - -
### POST `/api/withdraw`

#### Summary

Withdraw money from an account.

#### Requests

- **user_id**: Unique identifier of the user (required)
- **amount**: Withdrawal amount (required). Positive value expected.
- **comment**: Optional comment regarding the withdrawal.

#### Responses

- **200 OK**

  ```
  {
    "user_id": 1,
    "amount": -500.0,
    "comment": "ATM withdrawal",
    "balance": 2000.5
  }
  ```
  
- **409 Insufficient funds**

  ```
  {
    "error": "Insufficient funds",
    "message": "Insufficient funds",
    "current_balance": 300.0,
    "requested_amount": -500.0,
    "deficit": 200.0
  }
  ```
  
- **404 Not Found** Possible issues:
  * User not found
  * Bank account not found
  * Invalid endpoint

    ```
    {
      "error": "User not found",
      "message": "User not found",
      "user_id": 123 // Рresent depending on the error
    }
    ```

- **422 Unprocessable Entity** Validation failures:

  ```
  {
    "message": "The user id field must be at least 1.",
    "errors": {
      "user_id": ["The user id field must be at least 1."]
    }
  }
  ```
  
- - -
### POST `/api/transfer`

#### Summary

Transfer funds between users.

#### Requests

- **from_user_id**: Sender's user ID (required)
- **to_user_id**: Recipient's user ID (required)
- **amount**: Transfer amount (required). Should be positive.
- **comment**: Optional note about the transfer.

#### Responses

- **200 OK**

  ```
  {
    "from_user_id": 1,
    "to_user_id": 2,
    "amount": 300.0,
    "comment": "Loan repayment",
    "sender_balance": 1700.5,
    "recipient_balance": 800.0
  }
  ```
  
- **409 Insufficient funds**

  ```
  {
    "error": "Insufficient funds",
    "message": "Insufficient funds",
    "user_id": 1,
    "current_balance": 200,
    "requested_amount": -300,
    "deficit": 100
  }
  ```
  
- **404 Not Found** Potential problems:
  * User not found
  * Bank account not found
  * Endpoint not found

    ```
    {
      "error": "User not found",
      "message": "User not found",
      "user_id": 123 // Рresent depending on the error
    }
    ```

- **422 Unprocessable Entity** Validation errors:

	```
	{
	"message": "The user id field must be at least 1.",
		"errors": {
		  "user_id": ["The user id field must be at least 1."]
		}
	}
	```

- - -

## Interactive Documentation
After launching the application, detailed interactive documentation with examples and API testing capability is available at: 
``` 
http://your-domain/docs
```















