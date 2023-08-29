
push:
	@git add .
	@git commit -am "New release!"
	@git push

pull:
	@git pull

test:
	@bash calendar-script.sh

test-auth:
	@bash calendar-script.sh --auth

test-sync:
	@bash calendar-script.sh --sync

test-agenda:
	@cat ~/.today_agenda
