
push:
	@git add .
	@git commit -am "New release!"
	@git push

test:
	@bash calendar-script.sh

test-auth:
	@bash calendar-script.sh --auth

