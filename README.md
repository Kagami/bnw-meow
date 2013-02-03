# Bnw meow

Kawaii single-page web interface for https://bnw.im/ built on top of the great Chaplin framework.

## See it in action

http://meow.genshiken.org/

## Manual build

Assumed that you have Debian-based distro installed, use the following commands:

* Install build deps:

    % make install-deps

* Compile and minify all static to the deb\_dist/srv/bnw-meow/ dir:

    % make release

* Create deb package:

    % make deb

See Makefile for the more details.

## License

```
Bnw meow - kawaii single-page web interface

Written in 2013 by Kagami Hiiragi <kagami@genshiken.org>

To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
```
