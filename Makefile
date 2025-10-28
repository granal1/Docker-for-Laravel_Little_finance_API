
build-dev:
	docker compose build

app-install:
	mkdir -m 777 html
	git clone https://github.com/granal1/Laravel_Little_finance_API.git html

composer-update:
	docker compose run --rm php composer update

generate-app-key:
	docker compose run --rm php php artisan key:generate

database-migrate:
	docker compose run --rm php php artisan migrate

demo-seed:
	docker compose run --rm php php artisan db:seed

start-dev:
	docker compose up -d

app-cache-clear:
	docker compose exec php php artisan cache:clear
	docker compose exec php php artisan config:clear
	docker compose exec php php artisan event:clear
	docker compose exec php php artisan route:clear
	docker compose exec php php artisan view:clear

app-generate-doc:
	docker compose run --rm php php artisan scribe:generate

app-cache:
	docker compose exec php php artisan config:cache
	docker compose exec php php artisan event:cache
	docker compose exec php php artisan route:cache
	docker compose exec php php artisan view:cache

app-test:
	docker compose run --rm php vendor/bin/phpunit --coverage-text

app-test-to-html:
	docker compose run --rm php vendor/bin/phpunit --coverage-html coverage-report

stop-dev:
	docker compose down --remove-orphans

restart-dev: stop-dev start-dev
