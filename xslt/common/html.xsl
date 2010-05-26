<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="html"
                extension-element-prefixes="exsl"
                version="1.0">

<!--!!==========================================================================
HTML Output
Common utilities and CSS for transformations to HTML.
:Requires: gettext color icons

This stylesheet contains common templates for creating HTML output. The
*{html.output} template creates an output file for a node in the source XML
document, calling *{html.page} to create the actual output. Output files can
be either XHTML or HTML, depending on the @{html.xhtml} parameter.

This stylesheet matches #{/} and calls *{html.output} on the root XML element.
This works for most input formats. If you need to do something different, you
should override the match for #{/}.
-->
<xsl:template match="/">
  <xsl:call-template name="html.output">
    <xsl:with-param name="node" select="*"/>
  </xsl:call-template>
</xsl:template>



<!--@@==========================================================================
html.basename
The base filename of the primary output file.
:Revision:version="1.0" date="2010-05-25" status="final"

This parameter specifies the base filename of the primary output file, without
the filename extension. This is used by *{html.output} to determine the output
filename, and may be used by format-specific linking code. By default, it uses
the value of an #{id} or #{xml:id} attribute, if present. Otherwise, it uses
the static string #{index}.
-->
<xsl:param name="html.basename">
  <xsl:choose>
    <xsl:when test="/*/@xml:id">
      <xsl:value-of select="/*/@xml:id"/>
    </xsl:when>
    <xsl:when test="/*/@id">
      <xsl:value-of select="/*/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>index</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.xhtml
Whether to output XHTML.
:Revision:version="1.0" date="2010-05-25" status="final"

If this parameter is set to true, this stylesheet will output XHTML. Otherwise,
the output is assumed to be HTML. Note that for HTML output, the importing
stylesheet still needs to call #{xsl:namespace-alias} to map the XHTML namespace
to #{#default}. The @{html.namespace} will be set automatically based on this
parameter. Stylesheets can use this parameter to check the output type, for
example when using #{xsl:element}.
-->
<xsl:param name="html.xhtml" select="true()"/>


<!--@@==========================================================================
html.namespace
The XML namespace for the output document.
:Revision:version="1.0" date="2010-05-25" status="final"

This parameter specifies the XML namespace of all output documents. It will be
set automatically based on the ${html.xhtml} parameter, either to the XHTML
namespace, or to the empty namespace. Stylesheets can use this parameter when
using #{xsl:element}.
-->
<xsl:param name="html.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/1999/xhtml'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.extension
The filename extension for all output files.
:Revision:version="1.0" date="2010-05-25" status="final"

This parameter specifies a filename extension for all HTML output files. It
should include the leading dot. By default, #{.xhtml} will be used if
@{html.xhtml} is true; otherwise, #{.html} will be used.
-->
<xsl:param name="html.extension">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:text>.html</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.xhtml</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--**==========================================================================
html.output
-->
<xsl:template name="html.output">
  <xsl:param name="node" select="."/>
  <xsl:param name="href">
    <xsl:choose>
      <xsl:when test="$node/@xml:id">
        <xsl:value-of select="concat($node/@xml:id, $html.extension)"/>
      </xsl:when>
      <xsl:when test="$node/@id">
        <xsl:value-of select="concat($node/@id, $html.extension)"/>
      </xsl:when>
      <xsl:when test="exsl:has-same-node($node, /*)">
        <xsl:value-of select="concat($html.basename, $html.extension)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(generate-id(), $html.extension)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <exsl:document href="{$href}">
    <xsl:call-template name="html.page">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </exsl:document>
</xsl:template>

<!--**==========================================================================
html.page
-->
<xsl:template name="html.page">
  <xsl:param name="node" select="."/>
  <html>
    <head>
      <title>
        <xsl:apply-templates mode="html.title.mode" select="$node"/>
      </title>
      <xsl:call-template name="html.css"/>
      <xsl:call-template name="html.head.custom"/>
    </head>
    <body>
      <div class="header">
        <xsl:apply-templates mode="html.header.mode" select="$node"/>
      </div>
      <div class="body">
        <xsl:apply-templates mode="html.body.mode" select="$node"/>
      </div>
      <div class="footer">
        <xsl:apply-templates mode="html.footer.mode" select="$node"/>
      </div>
    </body>
  </html>
</xsl:template>


<!--%%==========================================================================
html.header.mode
-->
<xsl:template mode="html.header.mode" match="*"/>


<!--%%==========================================================================
html.footer.mode
-->
<xsl:template mode="html.footer.mode" match="*"/>


<!--%%==========================================================================
html.body.mode
-->
<xsl:template mode="html.body.mode" match="*"/>


<!--**==========================================================================
html.head.custom
Stub to output custom content for the HTML #{head} element.
:Stub: true
:Revision: version="1.0" date="2010-05-25" status="final"

This template is a stub, called by *{html.page}. You can override this template
to provide additional elements in the HTML #{head} element of output files.
-->
<xsl:template name="html.head.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.css
-->
<xsl:template name="html.css">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <style type="text/css">
    <xsl:call-template name="html.css.core">
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
    <xsl:call-template name="html.css.elements">
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
    <xsl:apply-templates mode="html.css.mode" select="$node">
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:apply-templates>
    <xsl:call-template name="html.css.custom">
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
  </style>
</xsl:template>


<!--%%==========================================================================
html.css.mode
Output CSS specific to the input format.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.
-->
<xsl:template mode="html.css.mode" match="*">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
</xsl:template>


<!--**==========================================================================
html.css.core
Output CSS that does not reference source elements.
:Revision: version="1.0" date="2010-05-25" status="final"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS that can be used in any HTML.  It does not reference
elements from DocBook, Mallard, or other source languages.  It provides the
common spacings for block-level elements lik paragraphs and lists, defines
styles for links, and defines four common wrapper divs: #{header}, #{side},
#{body}, and #{footer}.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.core">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:text>
html { height: 100%; }
body {
  margin: 0;
  padding-top: 1em;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
  background-color: </xsl:text>
    <xsl:value-of select="$color.gray_background"/><xsl:text>;
  color: </xsl:text>
    <xsl:value-of select="$color.text"/><xsl:text>;
  direction: </xsl:text><xsl:value-of select="$direction"/><xsl:text>;
  max-width: 73em;
  position: relative;
}
div.body {
  margin: 0;
  padding: 1em;
  max-width: 60em;
  min-height: 20em;
  background-color: </xsl:text>
    <xsl:value-of select="$color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
}
div.header {
  max-width: 60em;
}
div.footer {
  max-width: 60em;
}
div.sect {
  margin-top: 1.72em;
  clear: both;
}
div.sect div.sect {
  margin-top: 1.44em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
}
div.trails { margin: 0; }
div.trail {
  font-size: 0.83em;
  margin: 0 2.2em 0.2em 2.2em;
  padding: 0;
  text-indent: -1em;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
}
a.trail { white-space: nowrap; }
div.hgroup {
  margin: 0 0 0.5em 0;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
}
h1, h2, h3, h4, h5, h6, h7 {
  margin: 0; padding: 0;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
  font-weight: bold;
}
h1 { font-size: 1.44em; }
h2 { font-size: 1.2em; }
h3.title, h4.title, h5.title, h6.title, h7.title { font-size: 1.2em; }
h3, h4, h5, h6, h7 { font-size: 1em; }

p { line-height: 1.72em; }
div, pre, p { margin: 1em 0 0 0; padding: 0; }
div:first-child, pre:first-child, p:first-child { margin-top: 0; }
div.inner, div.contents, pre.contents { margin-top: 0; }
p img { vertical-align: middle; }

table {
  border-collapse: collapse;
  border-color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
  border-width: 1px;
}
td, th {
  padding: 0.5em;
  vertical-align: top;
  border-color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
  border-width: 1px;
}
thead td, thead th, tfoot td, tfoot th {
  padding: 0.2em 0.5em 0.2em 0.5em;
}

ul, ol, dl { margin: 0; padding: 0; }
li {
  margin: 1em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em;
  padding: 0;
}
li:first-child { margin-top: 0; }
dt { margin-top: 1em; }
dt:first-child { margin-top: 0; }
dt + dt { margin-top: 0; }
dd {
  margin: 0.2em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
}
ol.compact li { margin-top: 0.2em; }
ul.compact li { margin-top: 0.2em; }
ol.compact li:first-child { margin-top: 0; }
ul.compact li:first-child { margin-top: 0; }
dl.compact dt { margin-top: 0.2em; }
dl.compact dt:first-child { margin-top: 0; }
dl.compact dt + dt { margin-top: 0; }

a {
  text-decoration: none;
  color: </xsl:text><xsl:value-of select="$color.link"/><xsl:text>;
}
a:visited { color: </xsl:text>
  <xsl:value-of select="$color.link_visited"/><xsl:text>; }
a:hover { text-decoration: underline; }
a img { border: none; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.css.elements
Output CSS for common elements from source formats.
:Revision: version="1.0" date="2010-05-25" status="final"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS for elements from source languages like DocBook and
Mallard.  It defines them using common class names.  The common names are often
the simpler element names from Mallard, although there some class names which
are not taken from Mallard.  Stylesheets which convert to HTML should use the
appropriate common classes.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.elements">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:text>
div.title {
  margin: 0 0 0.2em 0;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
div.desc { margin: 0 0 0.2em 0; }
div.contents + div.desc { margin: 0.2em 0 0 0; }
pre.contents {
  padding: 0.5em 1em 0.5em 1em;
}
pre.linenumbering {
  margin: 0;
  padding: 0.5em;
  float: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 0.5em;
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.yellow_background"/><xsl:text>;
}
div.code {
  background: url('</xsl:text>
    <xsl:value-of select="$icons.code"/><xsl:text>') no-repeat top </xsl:text>
    <xsl:value-of select="$right"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
}
div.figure {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
  padding: 4px;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.gray_background"/><xsl:text>;
}
div.figure > div.inner > div.contents {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  text-align: center;
  color: </xsl:text>
    <xsl:value-of select="$color.text"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.background"/><xsl:text>;
}
div.list > div.title { margin-bottom: 0.5em; }
div.listing > div.inner { margin: 0; padding: 0; }
div.listing > div.inner > div.desc { font-style: italic; }
div.note {
  padding: 6px;
  border-top: solid 1px </xsl:text>
    <xsl:value-of select="$color.red_border"/><xsl:text>;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$color.red_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.yellow_background"/><xsl:text>;
}
div.note > div.inner > div.title {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.note + 6"/><xsl:text>px;
}
div.note > div.inner > div.contents {
  margin: 0; padding: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.note + 6"/><xsl:text>px;
}
div.note > div.inner {
  margin: 0; padding: 0;
  background-image: url("</xsl:text>
    <xsl:value-of select="$icons.note"/><xsl:text>");
  background-position: </xsl:text><xsl:value-of select="$left"/><xsl:text> top;
  background-repeat: no-repeat;
  min-height: </xsl:text><xsl:value-of select="$icons.size.note"/><xsl:text>px;
}
div.note-advanced div.inner { <!-- background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.advanced"/><xsl:text>"); --> }
div.note-bug div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.bug"/><xsl:text>"); }
div.note-important div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.important"/><xsl:text>"); }
div.note-tip div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.tip"/><xsl:text>"); }
div.note-warning div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.warning"/><xsl:text>"); }
div.quote {
  padding: 0;
  background-image: url('</xsl:text>
    <xsl:value-of select="$icons.quote"/><xsl:text>');
  background-repeat: no-repeat;
  background-position: top </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  min-height: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
div.quote > div.inner > div.title {
  margin: 0 0 0.5em 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
blockquote {
  margin: 0; padding: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
div.quote > div.inner > div.cite {
  margin-top: 0.5em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
div.quote > div.inner > div.cite::before {
  <!-- FIXME: i18n -->
  content: '&#x2015; ';
}
div.screen {
  background-color: </xsl:text>
    <xsl:value-of select="$color.gray_background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
}
ol.steps, ul.steps {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  border-top: solid 1px;
  border-bottom: solid 1px;
  border-color: </xsl:text>
    <xsl:value-of select="$color.blue_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.yellow_background"/><xsl:text>;
}
ol.steps .steps {
  padding: 0;
  border: none;
  background-color: none;
}
li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em; }
li.steps li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em; }
div.synopsis > div.inner > div.contents, div.synopsis > pre.contents {
  padding: 0.5em 1em 0.5em 1em;
  border-top: solid 1px;
  border-bottom: solid 1px;
  border-color: </xsl:text>
    <xsl:value-of select="$color.blue_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.gray_background"/><xsl:text>;
}
div.synopsis > div.inner > div.desc { font-style: italic; }
div.synopsis div.code {
  background: none;
  border: none;
  padding: 0;
}
div.synopsis div.code > pre.contents { margin: 0; padding: 0; }
.table {}
tr.shade {
  background-color: </xsl:text><xsl:value-of select="$color.gray_background"/><xsl:text>;
}
td.shade {
  background-color: </xsl:text><xsl:value-of select="$color.gray_background"/><xsl:text>;
}
tr.shade td.shade {
  background-color: </xsl:text><xsl:value-of select="$color.dark_background"/><xsl:text>;
}

span.app { font-style: italic; }
span.cmd {
  font-family: monospace;
  background-color: </xsl:text>
    <xsl:value-of select="$color.gray_background"/><xsl:text>;
  padding: 0 0.2em 0 0.2em;
}
span.cmd span.cmd { background-color: none; padding: 0; }
pre span.cmd { background-color: none; padding: 0; }
span.code {
  font-family: monospace;
  border-bottom: solid 1px </xsl:text><xsl:value-of select="$color.dark_background"/><xsl:text>;
}
span.code span.code { border: none; }
pre span.code { border: none; }
span.em { font-style: italic; }
span.em-bold {
  font-style: normal; font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
pre span.error {
  color: </xsl:text><xsl:value-of select="$color.text_error"/><xsl:text>;
}
span.file { font-family: monospace; }
span.gui, span.guiseq { color: </xsl:text>
  <xsl:value-of select="$color.text_light"/><xsl:text>; }
span.input { font-family: monospace; }
pre span.input {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
span.key {
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.yellow_border"/><xsl:text>;
  padding: 0 0.2em 0 0.2em;
}
span.keyseq {
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
}
span.output { font-family: monospace; }
pre span.output {
  color: </xsl:text><xsl:value-of select="$color.text"/><xsl:text>;
}
pre span.prompt {
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
span.sys { font-family: monospace; }
span.var { font-style: italic; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.css.custom
Stub to output custom CSS common to all HTML transformations.
:Stub: true
:Revision: version="1.0" date="2010-05-25" status="final"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template is a stub, called by *{html.css}.  You can override this
template to provide additional CSS that will be used by all HTML output.
-->
<xsl:template name="html.css.custom">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
</xsl:template>

</xsl:stylesheet>
