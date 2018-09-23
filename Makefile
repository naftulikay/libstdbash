#!/usr/bin/make -f

SHELL:=$(shell which bash)

bundler:
	@if ! which bundler &>/dev/null ; then \
		gem install bundler ; \
	fi

gems: bundler
	bundle install

init: gems

test:
	@echo 'FIXME: No tests implemented yet!' >&2
