# Node CLI utilities.
BRUNCH = node_modules/.bin/brunch
BOWER = node_modules/.bin/bower

# Deb-related settings.
NAME=bnw-meow
REVISION?=1
VERSION=$(shell ./version.coffee)-$(REVISION)
ARCH=all
BUILD_DIR=build
HTML_DIR=$(BUILD_DIR)/srv/$(NAME)
DEB_DIR=deb_dist
DEB_PATH=$(DEB_DIR)/$(NAME)_$(VERSION)_$(ARCH).deb

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

deb: clean
	mkdir -p "$(HTML_DIR)" "$(DEB_DIR)"
	cp -r deb/* "$(BUILD_DIR)"
	sed -i "s/^Version:.*/Version: $(VERSION)/" "$(BUILD_DIR)/DEBIAN/control"
	$(BRUNCH) build --production
	./index.coffee
	cp -r public/* "$(HTML_DIR)"
	fakeroot dpkg -b "$(BUILD_DIR)" "$(DEB_PATH)"

clean c:
	rm -rf public "$(BUILD_DIR)" "$(DEB_DIR)"

# REPORTER ?= spec
# # Deps required only for testing. All deps in 'install-deps' target
# # required as well.
# install-test-deps:
# 	sudo npm install -g mocha should
# test t:
# 	mocha tests/ --compilers coffee:coffee-script -r should -R $(REPORTER) \
# 		--ignore-leaks
