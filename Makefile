include node_modules/make-livescript/livescript.mk

.PHONY: test
test: all
	node_modules/.bin/lsc test/*.ls