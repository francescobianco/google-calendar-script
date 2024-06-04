
push:
	@git add .
	@git commit -am "New release!" || true
	@git push

pull:
	@git pull

test:
	@bash calendar-script.sh

test-auth:
	@bash tests/auth-test.sh

test-events:
	@bash tests/events-test.sh

test-date:
	@bash tests/date-test.sh

test-sync:
	@bash calendar-script.sh --sync

test-cron:
	@bash tests/cron-test.sh

test-info:
	@mush run -- --info

test-agenda:
	@cat ~/.today_agenda

test-help:
	@mush run -- --help
