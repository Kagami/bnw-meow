# Node CLI utilities.
BRUNCH=node_modules/.bin/brunch
BOWER=node_modules/.bin/bower
MOCHA=node_modules/.bin/mocha

# Deb-related settings.
NAME=bnw-meow
REVISION?=1
VERSION=$(shell ./version.coffee)-$(REVISION)
ARCH=all
BUILD_DIR=build
HTML_DIR=$(BUILD_DIR)/srv/$(NAME)
DEB_DIR=deb_dist
DEB_PATH=$(DEB_DIR)/$(NAME)_$(VERSION)_$(ARCH).deb

# Other settings.
REPORTER?=spec

all: build

# Install binary dependencies that you will need for building on
# Debian-based distro.
install-debian-deps:
	sudo apt-get install nodejs fakeroot

# Install node and bower dependencies.
# Don't forget to install binary deps.
# (In case of Debian use: `make install-debian-deps')
install-deps:
	npm install
	$(BOWER) install

config:
	cp app/scripts/config.coffee.example app/scripts/config.coffee

build: clean
	$(BRUNCH) build

watch w: clean
	$(BRUNCH) watch --server

deb: build test clean
	mkdir -p "$(HTML_DIR)" "$(DEB_DIR)"
	cp -r deb/* "$(BUILD_DIR)"
	sed -i "s/^Version:.*/Version: $(VERSION)/" "$(BUILD_DIR)/DEBIAN/control"
	$(BRUNCH) build --production
	./index.coffee
	cp -r public/* "$(HTML_DIR)"
	fakeroot dpkg -b "$(BUILD_DIR)" "$(DEB_PATH)"

test:
	NODE_PATH=app/scripts:vendor $(MOCHA) tests/ \
		--compilers=coffee:coffee-script \
		--require=should \
		--reporter=$(REPORTER)

t: REPORTER=nyan
t: test

clean c:
	rm -rf public "$(BUILD_DIR)" "$(DEB_DIR)"
