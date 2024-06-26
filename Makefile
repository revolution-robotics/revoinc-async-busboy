BUILD_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
NAME = $(shell jq -r .name $(BUILD_DIR)package.json | sed -e 's;@;;' -e 's;/;-;')
VERSION = $(shell jq -r .version $(BUILD_DIR)package.json)

SRCS =	$(BUILD_DIR)LICENSE.md						\
	$(BUILD_DIR)Makefile						\
	$(BUILD_DIR)README.md						\
	$(BUILD_DIR)examples/upload-file				\
	$(BUILD_DIR)index.js						\
	$(BUILD_DIR)package.json					\
	$(BUILD_DIR)specs.js

.PHONY: all install install-local uninstall publish

all: $(BUILD_DIR)$(NAME)-$(VERSION).tgz

install: all
	npm install -g $(BUILD_DIR)$(NAME)-$(VERSION).tgz

install-local:
	npm install

uninstall:
	npm uninstall -g $(NAME)

$(BUILD_DIR)$(NAME)-$(VERSION).tgz: $(SRCS)
	npm pack $(BUILD_DIR)

check test: install-local
	npm run test

publish: clean all
	npm publish $(BUILD_DIR)$(NAME)-$(VERSION).tgz

clean:
	rm -rf $(BUILD_DIR)*.tgz $(BUILD_DIR)node_modules $(BUILD_DIR)lib/word-list.js $(BUILD_DIR)*~
