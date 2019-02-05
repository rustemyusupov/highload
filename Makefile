ENV=local
dir=${CURDIR}
project=-p highload
service=eugenebalaban/laravel-php-fpm-debug

start:
	@docker-compose $(project) up -d

stop:
	@docker-compose $(project) down

update-images:
	@docker pull eugenebalaban/laravel-php-fpm-debug

restart: stop start

ssh:
	@docker-compose $(project) exec php-fpm sh

exec:
	@docker run -t -v $(dir):/var/www/html $(service) $$cmd

exec-db:
	@docker run -t -v $(dir):/var/www/html --network highload --link database $(service) $$cmd

сhmod:
	@make exec cmd="chmod -R 777 *"

composer-install:
	@make exec cmd="composer install"

composer-update:
	@make exec cmd="composer update"

migrate:
	@make exec-db cmd="php artisan migrate --force"

seed:
	@make exec-db cmd="php artisan db:seed --force"

fresh:
	@make exec-db cmd="php artisan migrate:fresh --seed"
