include node_modules/make-livescript/livescript.mk

watch:
	@while :; do inotifywait -qr -e modify -e create src; make; sleep 1; done

.PHONY: test
test: all
	node_modules/.bin/lsc test/*.ls