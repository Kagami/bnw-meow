# Node CLI utilities.
BRUNCH=node_modules/.bin/brunch
BOWER=node_modules/.bin/bower
MOCHA=node_modules/.bin/mocha

# Deb-related settings.
NAME=bnw-meow
REVISION?=1
VERSION=$(shell ./version.coffee)-$(REVISION)
ARCH=all
DEB_BUILD_DIR=build
HTML_DIR=$(DEB_BUILD_DIR)/srv/$(NAME)
DEB_DIR=deb_dist
DEB_PATH=$(DEB_DIR)/$(NAME)_$(VERSION)_$(ARCH).deb

# Other settings.
BUILD_DIR=public
TESTS_DIR=tests
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

release: test mrproper
	mkdir -p "$(HTML_DIR)" "$(DEB_DIR)"
	cp -r deb/* "$(DEB_BUILD_DIR)"
	sed -i \
		"s/^Version:.*/Version: $(VERSION)/" \
		"$(DEB_BUILD_DIR)/DEBIAN/control"
	$(BRUNCH) build --production
	./index.coffee
	cp -r $(BUILD_DIR)/* "$(HTML_DIR)"

deb: release
	chmod -R u=rwX,g=rX,o=rX "$(DEB_BUILD_DIR)"
	fakeroot dpkg -b "$(DEB_BUILD_DIR)" "$(DEB_PATH)"

test:
	NODE_PATH=app/scripts:bower_components $(MOCHA) "$(TESTS_DIR)" \
		--compilers=coffee:coffee-script \
		--require=should \
		--reporter=$(REPORTER)

t: REPORTER=nyan
t: test

test-ci: config test

clean c:
	rm -rf "$(BUILD_DIR)"

mrproper: clean
	rm -rf "$(DEB_BUILD_DIR)" "$(DEB_DIR)"
