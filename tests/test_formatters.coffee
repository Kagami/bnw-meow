requirejs = require "requirejs"

requirejs.config
  baseUrl: "#{__dirname}/../dist/static/js/"
  paths:
    underscore: "vendor/underscore"
    marked: "vendor/marked"
  shim:
    underscore:
      exports: "_"
  nodeRequire: require

formatters = requirejs "lib/formatters"

describe "Formatters", ->

  describe "escape2", ->
    it "should not escape simple strings", ->
      formatters.escape2("kkk").should.equal("kkk")

    it "should escape entities", ->
      formatters.escape2("<tag1><abcd></tag1>")
                .should.equal("&lt;tag1&gt;&lt;abcd&gt;&lt;/tag1&gt;")
      formatters.escape2("<http://test'\"&>")
                .should.equal("&lt;http://test&#39;&quot;&amp;&gt;")

  describe "Markdown", ->
    f = (text) ->
      formatters.format text

    it "should escape", ->
      f("Test <html><body><&\"'></body></html>").should.equal("<p>Test &lt;html&gt;&lt;body&gt;&lt;&amp;&quot;&#39;&gt;&lt;/body&gt;&lt;/html&gt;</p>\n")

    it "should parse post links", ->
      f("test: #0XYNTA").should.equal('<p>test: <a href="/p/0XYNTA">#0XYNTA</a></p>\n')
      f("test: #0XYNTA/123").should.equal('<p>test: <a href="/p/0XYNTA#123">#0XYNTA/123</a></p>\n')
      f("#0XY>NTA\n\nNyak").should.equal('<p><a href="/p/0XY">#0XY</a>&gt;NTA</p>\n<p>Nyak</p>\n')

    it "should correctly parse urls with anchors", ->
      f("http://example.com/#anchor").should.equal('<p><a href="http://example.com/#anchor">http://example.com/#anchor</a></p>\n')

    it "should parse user links", ->
      f("test: @nyashka").should.equal('<p>test: <a href="/u/nyashka">@nyashka</a></p>\n')
      f("Look at this nyashka:\n\n@nyashka\n\nNyak").should.equal('<p>Look at this nyashka:</p>\n<p><a href="/u/nyashka">@nyashka</a></p>\n<p>Nyak</p>\n')
      f("How about this:\n@super-&bad-nyashka\nNyak").should.equal('<p>How about this:<br><a href="/u/super-">@super-</a>&amp;bad-nyashka<br>Nyak</p>\n')

    it "should parse images as links", ->
      f("img: ![test](http://example.com/1.jpg)").should.equal('<p>img: <a href="http://example.com/1.jpg">test</a></p>\n')
      f("img: ![]()").should.equal('<p>img: <a href=""></a></p>\n')
      f("img: ![Test][id]\n[id]: http://example.com/1.gif").should.equal('<p>img: <a href="http://example.com/1.gif">Test</a></p>\n')

    it "should allow whitelisted protocols", ->
      f("[nyan](xmpp:jid@jabber.org)").should.equal('<p><a href="xmpp:jid@jabber.org">nyan</a></p>\n')

    it "should not allow unknown protocols", ->
      f("[test](javascript:test)").should.equal('<p>javascript:test</p>\n')
      f("[test][id]\n\n[id]: javascript:test\n\n[test2](javascript:nyak)").should.equal('<p>javascript:test</p>\n<p>javascript:nyak</p>\n')

    it "should not highlight users inside code", ->
      f("`test nyak @user nya`").should.equal('<p><code>test nyak @user nya</code></p>\n')
      input = """
      Nyak nyan `inline @user code`
      ```
      many lines code
      ```
      Another simple line @nyan
      ```
      multiline @user2 `inline @user3 inside code`
      ```
      end
      """
      output = """
      <p>Nyak nyan <code>inline @user code</code></p>
      <pre><code>many lines code</code></pre>
      <p>Another simple line <a href="/u/nyan">@nyan</a></p>
      <pre><code>multiline @user2 `inline @user3 inside code`</code></pre>
      <p>end</p>

      """
      f(input).should.equal(output)

    it "should not highlight messages inside code", ->
      f("`test msg: #0XYNTA`").should.equal('<p><code>test msg: #0XYNTA</code></p>\n')

  describe "MoinMoin", ->
    f = (text) ->
      formatters.format text, "moinmoin"

    it "should escape", ->
      f("Test <html><body><&\"'></body></html>").should.equal("Test &lt;html&gt;&lt;body&gt;&lt;&amp;&quot;&#39;&gt;&lt;/body&gt;&lt;/html&gt;")

    describe "Italic", ->
      it "should f simple italic", ->
        f("//Nyan nyan//").should.equal("<i>Nyan nyan</i>")

      it "should f italic on multiple lines", ->
        input = """
        Test desu!
        //Nyan nyan// nyan
         <- look at this!
        No at this: //desuu//"""
        output = "Test desu!<br /><i>Nyan nyan</i> nyan<br /> &lt;- look at this!<br />No at this: <i>desuu</i>"
        f(input).should.equal(output)

      it "should f multiline italic", ->
        input = """
        //line 1 text
        line2 text
        line3 line 3.//

        end."""
        output = "<i>line 1 text<br />line2 text<br />line3 line 3.</i><br /><br />end."
        f(input).should.equal(output)

    describe "Bold", ->
      it "should f simple bold", ->
        f("**Nya nya**").should.equal("<b>Nya nya</b>")

      it "should f bold on multiple lines", ->
        input = "Test\n**bold bold** test\n"
        output = "Test<br /><b>bold bold</b> test<br />"
        f(input).should.equal(output)

      it "should f multiline bold", ->
        input = """Test
        **Аниме в Ультра HD на японском ТВ “к 2014 году”
        Аниме в разрешении 3840×2160 “2160p” UHDTV должно быть доступно к лету 2014 года, так как японское правительство настаивает на развертывании вещания в формате 4K UHDTV на два года раньше чем это запланировано в попытке спасти телевизионную индустрию от краха.** [[http://www.animetank.ru/anime-v-ultra-hd-na-yaponskom-tv-k-2014-godu/ |❤❤❤]]
        Desu desu"""
        output = 'Test<br /><b>Аниме в Ультра HD на японском ТВ “к 2014 году”<br />Аниме в разрешении 3840×2160 “2160p” UHDTV должно быть доступно к лету 2014 года, так как японское правительство настаивает на развертывании вещания в формате 4K UHDTV на два года раньше чем это запланировано в попытке спасти телевизионную индустрию от краха.</b> <a href="http://www.animetank.ru/anime-v-ultra-hd-na-yaponskom-tv-k-2014-godu/">❤❤❤</a><br />Desu desu'
        f(input).should.equal(output)

    describe "URL", ->
      it "should parse url inside brackets", ->
        f("Mite mite — <http://example.com/>").should.equal('Mite mite — &lt;<a href="http://example.com/">http://example.com/</a>&gt;')

      it "should parse url at the start of line", ->
        f("http://example.com/").should.equal('<a href="http://example.com/">http://example.com/</a>')

      it "should parse several urls", ->
        input = """
        http://example.com/a/b/c
        http://example.com/new-cool-url
        """
        output = '<a href="http://example.com/a/b/c">http://example.com/a/b/c</a><br /><a href="http://example.com/new-cool-url">http://example.com/new-cool-url</a>'
        f(input).should.equal(output)

      it "should clip long urls", ->
        f("http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.BA.D0.BE.D1.80.D0.B4.D0.BD.D1.8B.D0.B5_.D0.BF.D1.80.D0.B8.D0.BC.D0.B5.D1.80.D1.8B_.D0.B3.D0.B8.D0.BF.D0.B5.D1.80.D0.B8.D0.BD.D1.84.D0.BB.D1.8F.D1.86.D0.B8.D0.B8").should.equal('<a href="http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.BA.D0.BE.D1.80.D0.B4.D0.BD.D1.8B.D0.B5_.D0.BF.D1.80.D0.B8.D0.BC.D0.B5.D1.80.D1.8B_.D0.B3.D0.B8.D0.BF.D0.B5.D1.80.D0.B8.D0.BD.D1.84.D0.BB.D1.8F.D1.86.D0.B8.D0.B8">http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.B.....8F.D1.86.D0.B8.D0.B8</a>')

      it "should parse urls inside lines", ->
        f("url: http://example.com/url <-\nhttp://url/ another url").should.equal('url: <a href="http://example.com/url">http://example.com/url</a> &lt;-<br /><a href="http://url/">http://url/</a> another url')

    describe "Code", ->
      it "should parse code block without language specified", ->
        f("{{{test nyak}}}").should.equal("<pre><code>test nyak</code></pre>")

      it "should parse code block with language specified", ->
        input = """
        Pretty coffeescript piece of code:

        {{{#!coffeescript
                  i = Math.min _(indexes).without(-1)...
                  [url, tail] = [url[...i], url[i..]]
                  urlText = @clipUrl url
        }}}

        """
        output = """
Pretty coffeescript piece of code:<br /><br /><pre><code class="language-coffeescript">          i = Math.min _(indexes).without(-1)...
          [url, tail] = [url[...i], url[i..]]
          urlText = @clipUrl url</code></pre>"""
        f(input).should.equal(output)
