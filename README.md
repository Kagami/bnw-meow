# bnw-meow ![meow](http://meow.bnw.im/static/favicon-big.png)

Kawaii single-page web interface for [bnw.im](https://github.com/stiletto/bnw) built on top of great Chaplin framework.

## See it in action

http://meow.bnw.im/

## Use with BnW

Send the following message to the bot:
```
set baseurl http://meow.bnw.im
```
Now all links that you get from bot will have correct prefix.

## Manual build

You could easily build and host you own version of bnw-meow. bnw-meow uses Brunch for build automation so you will need nodejs and npm installed.

**Preparing steps:**
```bash
# Install required binary dependencies in case of Debian.
% make install-debian-deps  # Or: sudo apt-get install nodejs fakeroot
# Install node and bower dependencies.
% make install-deps         # Or: npm install && ./node_modules/.bin/bower install
# Initialize default application config.
# You could edit it then manually if you want.
% make config               # Or: cp app/scripts/config.coffee.example app/scripts/config.coffee
```

* **Build development version:**
  ```bash
  % make  # Or: ./node_modules/.bin/brunch build
  ```

  It will build development version of static in the `public/` directory.

* **Build product version:**
  ```bash
  % ./node_modules/.bin/brunch build --production
  ```

  It will build product version of static in the `public/` directory.

* **Build deb package:**
  ```bash
  % make deb
  ```

  It will build debian package in the `deb_dist/` directory.

## Web server configuration

bnw-meow uses [HTML5 history API](http://diveintohtml5.info/history.html) so you will need some rewrite rules. See [bnw-meow.cfg](https://github.com/Kagami/bnw-meow/blob/master/deb/etc/nginx/sites-available/bnw-meow.cfg) for nginx example.

## Development

**Watch:**
```bash
% make watch  # Or: ./node_modules/.bin/brunch watch
```

It will start development web server on <http://localhost:4000/> and auto-recompile changed files.

**Test:**
```bash
% make test
```

## License

bnw-meow - kawaii single-page web interface for bnw.im

Written in 2013-2014 by Kagami Hiiragi <kagami@genshiken.org>

To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

---

**NOTE:** This license applied only to the bnw-meow code itself (this repository). You may not redistribute entire bnw-meow build under the CC0. Instead see the comments inside the generated files (`/static/*.css`, `/static/*.js`). Basically it's all MIT and BSD, so you will need to keep this comments in order to legally redistribute it.
