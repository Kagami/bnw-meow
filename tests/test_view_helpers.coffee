# Do some mocking
underscore = require "../dist/static/js/vendor/underscore"
helpers = undefined
global["define"] = (_deps, f) ->
  helpers = f(undefined, underscore)
require "../coffee/lib/view_helpers"


describe "View helpers", ->

  describe "escape2", ->
    it "should not escape simple strings", ->
      helpers.escape2("kkk").should.equal("kkk")

    it "should escape entities", ->
      helpers.escape2("<tag1><abcd></tag1>")
             .should.equal("&lt;tag1&gt;&lt;abcd&gt;&lt;/tag1&gt;")
      helpers.escape2("<http://test'\"&>")
             .should.equal("&lt;http://test&apos;&quot;&amp;&gt;")

  describe "formatText", ->
    format = (text) ->
      helpers.formatText text

    it "should escape", ->
      format("Test <html><body><&\"'></body></html>").should.equal("Test &lt;html&gt;&lt;body&gt;&lt;&amp;&quot;&apos;&gt;&lt;/body&gt;&lt;/html&gt;")

    describe "Italic", ->
      it "should format simple italic", ->
        format("//Nyan nyan//").should.equal("<i>Nyan nyan</i>")

      it "should format italic on multiple lines", ->
        input = """
Test desu!
//Nyan nyan// nyan
 <- look at this!
No at this: //desuu//"""
        output = "Test desu!<br /><i>Nyan nyan</i> nyan<br /> &lt;- look at this!<br />No at this: <i>desuu</i>"
        format(input).should.equal(output)

      it "should format multiline italic", ->
        input = """
//line 1 text
line2 text
line3 line 3.//

end."""
        output = "<i>line 1 text<br />line2 text<br />line3 line 3.</i><br /><br />end."
        format(input).should.equal(output)

    describe "Bold", ->
      it "should format simple bold", ->
        format("**Nya nya**").should.equal("<b>Nya nya</b>")

      it "should format bold on multiple lines", ->
        input = "Test\n**bold bold** test\n"
        output = "Test<br /><b>bold bold</b> test<br />"
        format(input).should.equal(output)

      it "should format multiline bold", ->
        input = """Test
**Аниме в Ультра HD на японском ТВ “к 2014 году”
Аниме в разрешении 3840×2160 “2160p” UHDTV должно быть доступно к лету 2014 года, так как японское правительство настаивает на развертывании вещания в формате 4K UHDTV на два года раньше чем это запланировано в попытке спасти телевизионную индустрию от краха.** [[http://www.animetank.ru/anime-v-ultra-hd-na-yaponskom-tv-k-2014-godu/ |❤❤❤]]
Desu desu"""
        output = 'Test<br /><b>Аниме в Ультра HD на японском ТВ “к 2014 году”<br />Аниме в разрешении 3840×2160 “2160p” UHDTV должно быть доступно к лету 2014 года, так как японское правительство настаивает на развертывании вещания в формате 4K UHDTV на два года раньше чем это запланировано в попытке спасти телевизионную индустрию от краха.</b> <a href="http://www.animetank.ru/anime-v-ultra-hd-na-yaponskom-tv-k-2014-godu/">❤❤❤</a><br />Desu desu'
        format(input).should.equal(output)

    describe "URL", ->
      it "should parse url inside brackets", ->
        format("Mite mite — <http://example.com/>").should.equal('Mite mite — &lt;<a href="http://example.com/">http://example.com/</a>&gt;')

      it "should parse url at the start of line", ->
        format("http://example.com/").should.equal('<a href="http://example.com/">http://example.com/</a>')

      it "should parse several urls", ->
        input = """
http://example.com/a/b/c
http://example.com/new-cool-url
"""
        output = '<a href="http://example.com/a/b/c">http://example.com/a/b/c</a><br /><a href="http://example.com/new-cool-url">http://example.com/new-cool-url</a>'
        format(input).should.equal(output)

      it "should clip long urls", ->
        format("http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.BA.D0.BE.D1.80.D0.B4.D0.BD.D1.8B.D0.B5_.D0.BF.D1.80.D0.B8.D0.BC.D0.B5.D1.80.D1.8B_.D0.B3.D0.B8.D0.BF.D0.B5.D1.80.D0.B8.D0.BD.D1.84.D0.BB.D1.8F.D1.86.D0.B8.D0.B8").should.equal('<a href="http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.BA.D0.BE.D1.80.D0.B4.D0.BD.D1.8B.D0.B5_.D0.BF.D1.80.D0.B8.D0.BC.D0.B5.D1.80.D1.8B_.D0.B3.D0.B8.D0.BF.D0.B5.D1.80.D0.B8.D0.BD.D1.84.D0.BB.D1.8F.D1.86.D0.B8.D0.B8">http://ru.wikipedia.org/wiki/Гиперинфляция#.D0.A0.D0.B5.D0.B.....8F.D1.86.D0.B8.D0.B8</a>')

      it "should parse urls inside lines", ->
        format("url: http://example.com/url <-\nhttp://url/ another url").should.equal('url: <a href="http://example.com/url">http://example.com/url</a> &lt;-<br /><a href="http://url/">http://url/</a> another url')

    describe "Code", ->
      it "should parse code block without language specified", ->
        format("{{{test nyak}}}").should.equal("<pre><code>test nyak</code></pre>")

      it "should parse code block with language specified", ->
        input = """
Pretty coffeescript piece of code:

{{{#!coffeescript
          i = Math.min _(indexes).without(-1)...
          [url, tail] = [url[...i], url[i..]]
          urlText = @clipUrl url
}}}

"""
        output = ''
        format(input).should.equal(output)
