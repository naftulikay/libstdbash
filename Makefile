#!/usr/bin/make -f

RUBY_MAJOR:=$(shell cat .ruby-version | awk -F . '{print $$1;}')
RUBY_MINOR:=$(shell cat .ruby-version | awk -F . '{print $$2;}')

export PATH="vendor/bundle/ruby/$(RUBY_MAJOR).$(RUBY_MINOR).0/bin:local/bin:$(shell echo $$PATH)"

SHELL:=$(shell which bash)

bundler:
	@if ! which bundler &>/dev/null ; then \
		gem install bundler ; \
	fi

gems: bundler
	@if ! which fpm &>/dev/null ; then \
		bundle install ; \
	fi

bats:
	@if [ ! -e local/bin/bats ]; then \
		d=$$(mktemp -d) ; \
		git clone https://github.com/sstephenson/bats.git $$d ; \
		$$d/install.sh local ; \
		rm -rf $$d ; \
	fi

init: bats gems

test: init
	@bats -p tests/
