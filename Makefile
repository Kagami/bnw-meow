STATIC = dist/static
INDEX_R = deb_dist/srv/bnw-meow
STATIC_R = "$(INDEX_R)/static"
VERSION = $(shell git rev-parse --short HEAD)
.PHONY: coffee

all: index coffee eco

# Install basic deps what you will need for building (or developing)
install-deps:
	sudo apt-get install npm gpp fakeroot
	# Also needed for watch script:
	# sudo apt-get install inotify-tools
	sudo npm install -g coffee-script
	npm install eco requirejs

config:
	cp coffee/config.coffee.example coffee/config.coffee

index:
	gpp -H -DVERSION=dev -o dist/index.html templates/index.gpp

index-release:
	gpp -H -DVERSION="$(VERSION)" -DRELEASE -o "$(INDEX_R)/index.html" \
		templates/index.gpp

coffee:
	coffee -o "$(STATIC)/js/" -bc coffee/

eco:
	-mkdir "$(STATIC)/js/templates/"
	bash -c 'ls templates/*.eco | while read file; do\
		tmp="`basename "$$file"`";\
		dest="$(STATIC)/js/templates/$${tmp/\.eco/.js}";\
		./eco.js "$$file" "$$dest";\
	done'

watch: all
	./watch.sh

pre-deb:
	rm -rf deb_dist/ *.deb
	cp -r deb/ deb_dist/
	find deb_dist/ -name '.*.swp' -delete
	mkdir -p "$(STATIC_R)/css/" "$(STATIC_R)/js/"
	cp -r "$(STATIC)/img/" "$(STATIC_R)"
	cp dist/favicon.ico "$(INDEX_R)"

minify:
	cat $(STATIC)/css/*.css > "$(STATIC_R)/css/default.css"
	./minify.js
	sed "s/^VERSION =.*/VERSION = '$(VERSION)';/" \
		"$(STATIC)/js/load_product.js" >> "$(STATIC_R)/js/meow.js"

release: pre-deb index-release coffee eco minify

deb: release
	fakeroot dpkg -b deb_dist/ bnw-meow.deb

clean:
	rm -rf deb_dist/ *.deb
	# Clean all compiled js files
	find $(STATIC)/js/ -mindepth 1 -maxdepth 1 ! -path '*/vendor' \
		-exec rm -r '{}' \;
