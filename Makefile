BRUNCH = node_modules/.bin/brunch
BOWER = node_modules/.bin/bower

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

clean c:
	rm -rf public

###
# OLD
###

# INDEX_R = deb_dist/srv/bnw-meow
# STATIC_R = "$(INDEX_R)/static"
# REPORTER ?= spec

# # Deps required only for testing. All deps in 'install-deps' target
# # required as well.
# install-test-deps:
# 	sudo npm install -g mocha should

# pre-deb:
# 	rm -rf deb_dist/ *.deb
# 	cp -r deb/ deb_dist/
# 	find deb_dist/ -name '.*.swp' -delete
# 	mkdir -p "$(STATIC_R)/css/" "$(STATIC_R)/js/"
# 	cp -r "$(STATIC)/font/" "$(STATIC_R)"
# 	cp dist/favicon.png "$(INDEX_R)"

# deb: release
# 	fakeroot dpkg -b deb_dist/ bnw-meow.deb

# test t:
# 	mocha tests/ --compilers coffee:coffee-script -r should -R $(REPORTER) \
# 		--ignore-leaks
