# bnw-meow

Kawaii single-page web interface from bnw.im built on top of the great Chaplin framework.

## See it in action

http://meow.bnw.im/

## Use with BnW

Send the following message to the bot:
```
set baseurl http://meow.bnw.im
```
Now all links what you get from bot will have correct prefix.

## Build

You will need node, npm and gpp ([Generic Preprocessor](http://files.nothingisreal.com/software/gpp/gpp.html)) installed.
Just run:
```
% sudo npm install -g coffee-script
% npm install eco requirejs
% make config
% make release
```
It will compile and minify all static to the `deb_dist/srv/bnw-meow/` dir.  
If you use Debian-based distro you could also use the following commands:

* Install build deps:
```
% make install-deps
```

* Create deb package:
```
% make deb
```

See [Makefile](https://github.com/Kagami/bnw-meow/blob/master/Makefile) for the more details.

## Web server configuration

bnw-meow uses HTML5's [pushState](http://diveintohtml5.info/history.html) techology so you will need some rewrite rules.  
See [bnw-meow.cfg](https://github.com/Kagami/bnw-meow/blob/master/deb/etc/nginx/sites-available/bnw-meow.cfg) for the nginx example.

## License

bnw-meow - kawaii single-page web interface for bnw.im

Written in 2013 by Kagami Hiiragi <kagami@genshiken.org>

To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
