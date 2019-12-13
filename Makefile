.DEFAULT_GOAL := usage

build:
	docker-compose build

up:
	rm -rf tmp/pids/server.pid
	docker-compose up

stop:
	docker-compose stop

bundle:
	docker-compose run --rm app bundle install

console:
	docker-compose run --rm app bundle exec rails console

rubocop-fix:
	docker-compose run --rm app bundle exec rubocop --auto-correct

rspec:
	docker-compose run --rm app bundle exec rspec ${OPTS} --profile -- ${TARGETS}
