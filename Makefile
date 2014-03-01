include node_modules/make-livescript/livescript.mk

.PHONY: test cover watch
test: cover
	node_modules/.bin/istanbul report text
	node_modules/.bin/istanbul check-coverage --statements 99 --branches 99 --functions 99

cover: all
	node_modules/.bin/istanbul cover -x run-tests.js run-tests.js

coverage-report: coverage/index.html

coverage/index.html: cover
	node_modules/.bin/istanbul report html

watch:
	fswatch src:test 'make coverage-report'