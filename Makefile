STATIC = dist/static
REVISION = $(shell git rev-parse --short HEAD)
.PHONY: coffee

all: index coffee eco

# Basic deps what you will need for developing bnw_meow
install-deps:
	sudo apt-get install npm inotify-tools
	sudo npm install -g coffee-script
	npm install eco requirejs

index:
	gpp -H -DVERSION=dev -o dist/index.html templates/index.gpp

index-release:
	gpp -H -DVERSION=$(REVISION) -DPRODUCT -o dist2/index.html \
		templates/index.gpp

coffee:
	coffee -o $(STATIC)/js/ -bc coffee/

eco:
	-mkdir $(STATIC)/js/templates/
	bash -c 'ls templates/*.eco | while read file; do\
		tmp="`basename "$$file"`";\
		dest="$(STATIC)/js/templates/$${tmp/\.eco/.js}";\
		./eco.js "$$file" "$$dest";\
	done'

watch: coffee eco
	./watch.sh

clean:
	rm -rf dist2/

release: clean index-release coffee eco
