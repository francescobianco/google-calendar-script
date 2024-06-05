
install:
	@mush install --path .

## ======
## DevOps
## ======

push:
	@git add .
	@git commit -am "New release!" || true
	@git push

pull:
	@git pull

## =====
## Tests
## =====

test:
	@bash calendar-script.sh

test-auth:
	@bash tests/auth-test.sh

test-events:
	@bash tests/events-test.sh

test-date:
	@bash tests/date-test.sh

test-sync:
	@mush run -- --sync

test-cron:
	@bash tests/cron-test.sh

test-info:
	@mush run -- --info

test-agenda:
	@cat ~/.today_agenda

test-help:
	@mush run -- --help

test-logs:
	@mush run -- --logs
