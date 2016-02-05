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
along with this program; see the file COPYING.LGPL. If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="html mml set its"
                extension-element-prefixes="exsl"
                version="1.0">

<!--!!==========================================================================
HTML Output
Common utilities and CSS for transformations to HTML.
:Requires: l10n color icons
:Revision:version="1.0" date="2010-05-26" status="final"

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
html.mathml.namespace
The XML namespace for MathML in the output document.
:Revision:version="3.18" date="2015-05-04" status="final"

This parameter specifies the XML namespace for MathML in output documents. It
will be set automatically based on the ${html.xhtml} parameter, either to the
MathML namespace namespace, or to the empty namespace. Stylesheets can use this
parameter when using #{xsl:element}.
-->
<xsl:variable name="html.mathml.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/1998/Math/MathML'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<!--@@==========================================================================
html.svg.namespace
The XML namespace for SVG in the output document.
:Revision:version="3.18" date="2015-05-04" status="final"

This parameter specifies the XML namespace for SVG in output documents. It
will be set automatically based on the ${html.xhtml} parameter, either to the
SVG namespace namespace, or to the empty namespace. Stylesheets can use this
parameter when using #{xsl:element}.
-->
<xsl:variable name="html.svg.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/2000/svg'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


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
      <xsl:text>.xhtml</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.html</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.css.root
The URI root for external CSS files.
:Revision:version="1.0" date="2010-12-06" status="final"

This parameter provides a root URI for any external CSS files that are
referenced from the output HTML file. If non-empty, it must end with
a trailing slash character.
-->
<xsl:param name="html.css.root" select="''"/>


<!--@@==========================================================================
html.js.root
The URI root for external JavaScript files.
:Revision:version="1.0" date="2010-12-06" status="final"

This parameter provides a root URI for any external JavaScript files that are
referenced from the output HTML file. If non-empty, it must end with
a trailing slash character.
-->
<xsl:param name="html.js.root" select="''"/>


<!--@@==========================================================================
html.syntax.highlight
Whether to include syntax highlighting support for code blocks.
:Revision:version="1.0" date="2010-12-06" status="final"

This parameter specifies whether syntax highlighting should be enabled for
code blocks in the output HTML. Syntax highlighting is done at document load
time by JavaScript.
-->
<xsl:param name="html.syntax.highlight" select="true()"/>


<!--**==========================================================================
html.output
Create an HTML output file.
:Revision:version="1.0" date="2010-05-26" status="final"
$node: The node to create an output file for.
$href: The output filename.

This template creates an HTML output file for the source element ${node}. It
uses #{exsl:document} to output the file, and calls *{html.page} with the
${node} parameter to output the actual HTML contents.

If ${href} is not provided, this template will attempt to generate a base
filename and append @{html.extension} to it. The base filename is generated
as follows: If an #{xml:id} attribute is present, it is used; otherwise, if
an #{id} attribute is present, it is uses; otherwise, if ${node} is the root
element, @{html.basename} is used; otherwise, #{generate-id()} is called.

After calling #{exsl:document}, this template calls the %{html.output.after.mode}
mode on ${node}. Importing stylesheets that create multiple output files can
use this to process output files without blocking earlier output.
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
      <xsl:when test="set:has-same-node($node, /*)">
        <xsl:value-of select="concat($html.basename, $html.extension)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(generate-id(), $html.extension)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <exsl:document href="{$href}">
	<xsl:call-template name="html.page">
	  <xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
      </exsl:document>
    </xsl:when>
    <xsl:otherwise>
      <exsl:document href="{$href}" method="html"
		     doctype-system="about:legacy-compat">
	<xsl:call-template name="html.page">
	  <xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
      </exsl:document>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates mode="html.output.after.mode" select="$node"/>
</xsl:template>



<!--%%==========================================================================
html.output.after.mode
Process an element after its content are output.
:Revision:version="1.0" date="2010-05-26" status="final"

This mode is called by *{html.output} after #{exsl:document} has finished. It
can be used to create further output files without blocking the output of
parent elements.
-->
<xsl:template mode="html.output.after.mode" match="*"/>


<!--**==========================================================================
html.page
Create an HTML document.
:Revision:version="1.0" date="2010-05-26" status="final"
$node: The node to create HTML for.

This template creates the actual HTML output for ${node}. It outputs top-level
elements and container divs, and calls various templates and modes to output
the inner content. Importing stylesheets should implement at least
%{html.title.mode} and %{html.body.mode} for any elements that could be passed
as ${node} to this template.
-->
<xsl:template name="html.page">
  <xsl:param name="node" select="."/>
  <html>
    <head>
      <meta name="viewport"
            content="width=device-width, initial-scale=1.0, user-scalable=yes"/>
      <title>
        <xsl:apply-templates mode="html.title.mode" select="$node"/>
      </title>
      <xsl:call-template name="html.css">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:call-template name="html.js">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:call-template name="html.head.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </head>
    <body>
      <xsl:call-template name="html.lang.attrs">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates mode="html.body.attr.mode" select="$node"/>
      <xsl:call-template name="html.top.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <div class="page" role="main">
        <header>
          <div class="inner">
          <xsl:call-template name="html.header.custom">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
          <xsl:apply-templates mode="html.header.mode" select="$node"/>
          </div>
        </header>
        <article>
          <xsl:apply-templates mode="html.body.mode" select="$node"/>
        </article>
        <footer>
          <div class="inner">
          <xsl:apply-templates mode="html.footer.mode" select="$node"/>
          <xsl:call-template name="html.footer.custom">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
          </div>
        </footer>
      </div>
      <xsl:call-template name="html.bottom.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>


<!--%%==========================================================================
html.title.mode
Output the title of an element.
:Revision:version="1.0" date="2010-05-26" status="final"

This mode is called by *{html.page} to output the contents of the HTML #{title}
element inside the #{head} element. Importing stylesheets should implement this
mode for any element that will be passed to *{html.page}. Because this is used
in the #{head}, the output should be text-only.
-->
<xsl:template mode="html.title.mode" match="*"/>


<!--%%==========================================================================
html.body.attr.mode
Output attributes for the HTML #{body} element.
:Revision:version="1.0" date="2010-06-08" status="final"

This mode is called by *{html.page} to output attributes on the HTML #{body}
element. No attributes are output by default. Importing stylesheets may
implement this node to add attributes for styling, data, or other purposes.
-->
<xsl:template mode="html.body.attr.mode" match="*"/>


<!--**==========================================================================
html.top.custom
Stub to output HTML at the top of the page.
:Stub: true
:Revision: version="1.0" date="2011-11-01" status="final"
$node: The node a page is being created for.

This template is a stub, called by *{html.page}. It is called before the
#{div.page} wrapper div. Override this template to provide site-specific HTML
at the top of the page.
-->
<xsl:template name="html.top.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.bottom.custom
Stub to output HTML at the bottom of the page.
:Stub: true
:Revision: version="1.0" date="2011-11-01" status="final"
$node: The node a page is being created for.

This template is a stub, called by *{html.page}. It is called after the
#{div.page} wrapper div. Override this template to provide site-specific HTML
at the bottom of the page.
-->
<xsl:template name="html.bottom.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.header.custom
Stub to output custom header content.
:Stub: true
:Revision: version="1.0" date="2011-10-27" status="final"
$node: The node a page is being created for.

This template is a stub, called by *{html.page}. It is called inside the header
div, before %{html.header.mode} is applied to ${node}. You can override this
template to provide additional content at the top of the page.
-->
<xsl:template name="html.header.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--%%==========================================================================
html.header.mode
Output the header content for an element.
:Revision:version="1.0" date="2010-05-26" status="final"

This mode is called by *{html.page} to output the contents of the header div
above the main content. Importing stylesheets may implement this mode for any
element that will be passed to *{html.page}. If they do not, the header div
will be empty.
-->
<xsl:template mode="html.header.mode" match="*"/>


<!--**==========================================================================
html.footer.custom
Stub to output custom footer content.
:Stub: true
:Revision: version="1.0" date="2011-10-27" status="final"
$node: The node a page is being created for.

This template is a stub, called by *{html.page}. It is called inside the footer
div, after %{html.footer.mode} is applied to ${node}. You can override this
template to provide additional content at the bottom of the page.
-->
<xsl:template name="html.footer.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--%%==========================================================================
html.footer.mode
Output the footer content for an element.
:Revision:version="1.0" date="2010-05-26" status="final"

This mode is called by *{html.page} to output the contents of the footer div
below the main content. Importing stylesheets may implement this mode for any
element that will be passed to *{html.page}. If they do not, the footer div
will be empty.
-->
<xsl:template mode="html.footer.mode" match="*"/>


<!--%%==========================================================================
html.body.mode
Output the main contents for an element.
:Revision:version="1.0" date="2010-05-26" status="final"

This mode is called by *{html.page} to output the main contents of an HTML
page, below the header content and above the footer content. Titles, block
content, and sections should be output in this mode.
-->
<xsl:template mode="html.body.mode" match="*"/>


<!--**==========================================================================
html.head.custom
Stub to output custom content for the HTML #{head} element.
:Stub: true
:Revision: version="1.0" date="2010-05-25" status="final"
$node: The node a page is being created for.

This template is a stub, called by *{html.page}. You can override this template
to provide additional elements in the HTML #{head} element of output files.
-->
<xsl:template name="html.head.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.linktrails.empty
Stub to output something when no link trails are present.
:Stub: true
:Revision:version="3.20" date="2015-10-02" status="final"
$node: The source element a page is bring created for.

This template is a stub. It is called by templates that output link trails when
there are no link trails to output. Some customizations prepend extra site links
to link trails. This template allows them to output those links even when no link
trails would otherwise be present.
-->
<xsl:template name="html.linktrails.empty">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.linktrails.prefix
Stub to output extra content before a link trail.
:Stub: true
:Revision:version="3.20" date="2015-10-02" status="final"
$node: A source-specific element providing information about the link trail.

This template is a stub. It is called by templates that output link trails
before the normal links are output. This template is useful for adding extra
site links at the beginning of each link trail.
-->
<xsl:template name="html.linktrails.prefix">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.class.attr
Output a #{class} attribute for an HTML element.
:Revision: version="3.10" date="2013-07-10" status="final"
$node: The source node for which an HTML element is being output.
$class: The value of the #{class} attribute provided by the calling template.

This template is called by templates that output an HTML element corresponding
to a source element. This template applies %{html.class.attr.mode} to ${node}
to gather a value from extensions stylesheets. It combines this value with the
value passed in the ${class} parameter and, if the result is non-empty, outputs
a #{class} attribute.
-->
<xsl:template name="html.class.attr">
  <xsl:param name="node" select="."/>
  <xsl:param name="class"/>
  <xsl:variable name="fclass">
    <xsl:value-of select="$class"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="html.class.attr.mode" select="$node"/>
  </xsl:variable>
  <xsl:variable name="nclass" select="normalize-space($fclass)"/>
  <xsl:if test="$nclass != ''">
    <xsl:attribute name="class">
      <xsl:value-of select="$nclass"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
html.class.attr.mode
Output additional values for an HTML #{class} attribute.
:Revision:version="3.10" date="2013-07-10" status="final"

This mode is called by *{html.class.attr} on a source element. This mode is
intended for extensions to have an easy way to add additional HTML class values
for styling.

Note that these stylesheets use CSS classes extensively for styling and for
certain JavaScript functionality. Extensions should be careful to output class
values that do not conflict with those used in these stylesheets.
-->
<xsl:template mode="html.class.attr.mode" match="*"/>


<!--**==========================================================================
html.css
Output all CSS for an HTML output page.
:Revision:version="1.0" date="2010-12-23" status="final"
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template creates the CSS for an HTML output page, including the enclosing
HTML #{style} element. It calls the templates *{html.css.content} to output the
actual CSS contents.

The ${direction} parameter specifies the directionality of the text for the
language of the document. The ${left} and ${right} parameters are based on
${direction}, and can be used to set beginning and ending margins or other
dimensions. All parameters can be automatically computed if not provided.
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
    <xsl:call-template name="html.css.content">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
  </style>
</xsl:template>


<!--**==========================================================================
html.css.content
Output actual CSS content for an HTML output page.
:Revision:version="1.0" date="2010-12-23" status="final"
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template creates the CSS content for an HTML output page. It is called by
*{html.css}. It calls the templates *{html.css.core}, *{html.css.elements}, and
*{html.css.syntax}. It then calls the mode %{html.css.mode} on ${node} and
calls the template *{html.css.custom}.
-->
<xsl:template name="html.css.content">
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
  <xsl:call-template name="html.css.core">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="html.css.elements">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="html.css.syntax">
    <xsl:with-param name="node" select="$node"/>
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
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
</xsl:template>


<!--%%==========================================================================
html.css.mode
Output CSS specific to the input format.
:Revision:version="1.0" date="2010-05-26" status="final"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template is called by *{html.css.content} to output CSS specific to the
input format. Importing stylesheets may implement this for any element that
will be passed to *{html.page}. If they do not, the output HTML will only have
the common CSS.
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
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS that can be used in any HTML. It does not reference
elements from DocBook, Mallard, or other source languages. It provides the
common spacings for block-level elements lik paragraphs and lists, defines
styles for links, and defines four common wrapper divs: #{header}, #{side},
#{body}, and #{footer}.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.core">
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
  <xsl:text>
html { height: 100%; }
body {
  font-family: sans-serif;
  margin: 0; padding: 0;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg"/><xsl:text>;
  color: </xsl:text>
    <xsl:value-of select="$color.fg"/><xsl:text>;
  direction: </xsl:text><xsl:value-of select="$direction"/><xsl:text>;
}
article, aside, nav, header, footer, section {
  display: block;
  margin: 0;
  padding: 0;
}
div.page {
  margin: 0;
  display: flex;
  flex-flow: column;
  align-items: stretch;
  justify-content: flext-start;
  min-height: 100vh;
}
div.page > article { flex: 1 0 100%; }
div.page > header, div.page > footer { flex: 0 1 auto; }
div.page > header > div.inner, div.page > footer > div.inner {
  max-width: 960px;
  margin: 0 auto;
  padding: 0;
}
article {
  padding: 10px 0;
  min-height: 20em;
  background-color: </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
}
article > nav,
article > div.hgroup,
article > div.region > div.contents,
article > div.region > nav,
article > div.region > section > div.inner > * {
  max-width: 940px;
  margin-left: auto;
  margin-right: auto;
  padding-left: 10px;
  padding-right: 10px;
}
section {
  margin-top: 2.4em;
  clear: both;
}
section section {
  margin-top: 1.44em;
}
.yelp-hash-highlight {
  animation-name: yelp-hash-highlight;
  animation-duration: 0.5s;
  animation-fill-mode: forwards;
}
@keyframes yelp-hash-highlight {
  from { transform: translateY(0px) }
  25%  { transform: translateY(20px); }
  50%  { transform: translateY(0); }
  75%  { transform: translateY(10px); }
  to   { transform: translateY(0px); }
}
div.trails {
  margin: 0;
  padding: 0.2em 10px;
  background-color: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
div.trail {
  margin: 0.2em 0;
  padding: 0 1em 0 1em;
  text-indent: -1em;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
a.trail { white-space: nowrap; }
div.hgroup {
  margin: 0 0 0.5em 0;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
section > div.inner > div.hgroup {
  margin-top: 0;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
section section > div.inner > div.hgroup {
  margin-left: -10px;
  margin-right: -10px;
  padding-left: 10px;
  padding-right: 10px;
}
section.links > div.inner > div.hgroup {
  border-bottom: solid 2px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
section section.links > div.inner > div.hgroup {
  border: none;
}
h1, h2, h3, h4, h5, h6, h7 {
  margin: 0; padding: 0;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  font-weight: bold;
}
h1 { font-size: 2em; }
h2 { font-size: 1.44em; }
h3.title, h4.title, h5.title, h6.title, h7.title { font-size: 1.2em; }
h3, h4, h5, h6, h7 { font-size: 1em; }
p { line-height: 1.44em; }
div, pre, p { margin: 0; padding: 0; }
div.contents > * + *,
th > * + *, td > * + *,
dt > * + *, dd > * + *,
li > * + * { margin-top: 1em; }
p img { vertical-align: middle; }
p.lead { font-size: 1.2em; }
div.clear {
  margin: 0; padding: 0;
  height: 0; line-height: 0;
  clear: both;
}
.center { text-align: center; }

footer.about {
  color: </xsl:text><xsl:value-of select="$color.fg.gray"/><xsl:text>;
  margin: 0;
  background-color: </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
}
footer.about > div.inner > div.hgroup {
  margin: 0; padding: 0;
  text-align: center;
  border: none;
}
footer.about > div.inner > div.hgroup > h2 {
  margin: 0; padding: 0.2em;
  font-size: inherit;
}
footer.about.ui-expander > div.inner > div.hgroup span.title:before {
  content: "";
}
div.copyrights {
  max-width: 700px;
  text-align: center;
  padding: 10px;
  margin: 0 auto;
}
div.copyright { margin: 0; }
div.credits {
  display: flex;
  flex-flow: row wrap;
  align-items: stretch;
  justify-content: flex-start;
  max-width: 720px;
  margin: 0 auto;
}
div.credits > * {
  vertical-align: top;
  text-align: left;
  flex: 1 0 220px;
  margin: 0;
  padding: 10px;
}
div.credits > *:empty { padding: 0 10px; height: 0; }
ul.credits, ul.credits li {
  margin: 0; padding: 0;
  list-style-type: none;
}
ul.credits li {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
  text-indent: -1em;
}
div.license {
  max-width: 700px;
  margin: 0 auto;
  padding: 10px;
}

table {
  border-collapse: collapse;
  border-color: </xsl:text><xsl:value-of select="$color.gray"/><xsl:text>;
  border-width: 1px;
}
td, th {
  padding: 0.5em;
  vertical-align: top;
  border-color: </xsl:text><xsl:value-of select="$color.gray"/><xsl:text>;
  border-width: 1px;
}
thead td, thead th, tfoot td, tfoot th {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  background-color: </xsl:text><xsl:value-of select="$color.bg.dark"/><xsl:text>;
}
th {
  text-align: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}

ul, ol, dl { margin: 0; padding: 0; }
li {
  margin: 1em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em;
  padding: 0;
}
li:first-child { margin-top: 0; }
@media (max-width: 480px) {
  li {
    margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
  }
}
dt { margin-top: 1em; }
dt:first-child { margin-top: 0; }
dt + dt { margin-top: 0; }
dd {
  margin: 0.2em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
}
dd + dd { margin-top: 1em; }
ol.compact li { margin-top: 0.2em; }
ul.compact li { margin-top: 0.2em; }
ol.compact li:first-child { margin-top: 0; }
ul.compact li:first-child { margin-top: 0; }
dl.compact dt { margin-top: 0.2em; }
dl.compact dt:first-child { margin-top: 0; }
dl.compact dt + dt { margin-top: 0; }

a {
  text-decoration: none;
  color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
a:visited { color: </xsl:text>
  <xsl:value-of select="$color.fg.purple"/><xsl:text>; }
a:hover {
  border-bottom: dotted 1px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
p a {
  border-bottom: dotted 1px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
a img { border: none; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.css.elements
Output CSS for common elements from source formats.
:Revision: version="1.0" date="2010-05-25" status="final"
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS for elements from source languages like DocBook and
Mallard. It defines them using common class names. The common names are often
the simpler element names from Mallard, although there some class names which
are not taken from Mallard. Stylesheets which convert to HTML should use the
appropriate common classes.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.elements">
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
  <xsl:text>
div.title {
  margin: 0 0 0.2em 0;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
div.title h1, div.title h2, div.title h3, div.title h4, div.title h5, div.title h6 {
  margin: 0;
  font-size: inherit;
  font-weight: inherit;
  color: inherit;
}
div.desc { margin: 0 0 0.2em 0; }
div.contents + div.desc { margin: 0.2em 0 0 0; }
pre.contents {
  padding: 0.5em 1em 0.5em 1em;
}
div.links-center { text-align: center; }
div.links .desc { color: </xsl:text><xsl:value-of select="$color.fg.gray"/><xsl:text>; }
div.links > div.inner > div.region > div.desc { font-style: italic; }
div.links ul { margin: 0; padding: 0; }
div.links ul ul {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}
li.links {
  margin: 0.5em 0 0.5em 0;
  padding: 0;
  list-style-type: none;
}
div.sectionlinks {
  display: inline-block;
  padding: 0 1em 0 1em;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.blue"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
div.sectionlinks ul { margin: 0; }
div.sectionlinks li { padding: 0; }
div.sectionlinks div.title { margin: 0.5em 0 0.5em 0; }
div.sectionlinks div.sectionlinks {
  display: block;
  margin: 0.5em 0 0 0;
  padding: 0;
  border: none;
}
div.sectionlinks div.sectionlinks li {
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
}
nav.prevnext { clear: both; }
div.region > nav.prevnext, div.region + nav.prevnext { margin-top: 1em; }
nav.prevnext > div.inner { float: </xsl:text><xsl:value-of select="$right"/><xsl:text>; }
nav.prevnext > div.inner > * {
  background-color: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
  display: inline-block;
  position: relative;
  height: 1.44em;
  padding: 0.2em 0.83em 0 0.83em;
  margin-bottom: 1em;
  border: solid 1px </xsl:text><xsl:value-of select="$color.gray"/><xsl:text>;
}
nav.prevnext > div.inner > span { visibility: hidden; }
nav.prevnext > div.inner > a + a {
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: none;
}
nav.prevnext > div.inner > a:first-child {
  border-top-</xsl:text><xsl:value-of select="$left"/><xsl:text>-radius: 2px;
  border-bottom-</xsl:text><xsl:value-of select="$left"/><xsl:text>-radius: 2px;
}
nav.prevnext > div.inner > a:last-of-type {
  border-top-</xsl:text><xsl:value-of select="$right"/><xsl:text>-radius: 2px;
  border-bottom-</xsl:text><xsl:value-of select="$right"/><xsl:text>-radius: 2px;
}
div.serieslinks {
  display: inline-block;
  padding: 0 1em 0 1em;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.blue"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
div.serieslinks ul { margin: 0; }
div.serieslinks li { padding: 0; }
div.serieslinks div.title { margin: 0.5em 0 0.5em 0; }
pre.numbered {
  margin: 0;
  padding: 0.5em;
  float: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 0.5em;
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  color: </xsl:text><xsl:value-of select="$color.fg.gray"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
}
div.code {
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
div.example {
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 4px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}
div.example > div.inner > div.region > div.desc { font-style: italic; }
div.figure {
  display: inline-block;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
  padding: 4px;
  color: </xsl:text>
    <xsl:value-of select="$color.fg.dark"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
@media (max-width: 960px) {
  div.figure {
    margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
  }
}
div.figure > div.inner > a.zoom {
  float: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
}
div.figure > div.inner > div.region > div.contents {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  clear: both;
  text-align: center;
  color: </xsl:text>
    <xsl:value-of select="$color.fg"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg"/><xsl:text>;
}
div.list > div.inner > div.title { margin-bottom: 0.5em; }
div.listing > div.inner { margin: 0; padding: 0; }
div.listing > div.inner > div.region > div.desc { font-style: italic; }
div.note {
  padding: 6px;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.bg.dark"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
div.note > div.inner > div.title {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.note + 6"/><xsl:text>px;
}
div.note > div.inner > div.region > div.contents {
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
div.note-advanced > div.inner { <!-- background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.advanced"/><xsl:text>"); --> }
div.note-bug > div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.bug"/><xsl:text>"); }
div.note-important > div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.important"/><xsl:text>"); }
div.note-tip > div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.tip"/><xsl:text>"); }
div.note-warning > div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$icons.note.warning"/><xsl:text>"); }
div.note-sidebar {
  float: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  max-width: 40%;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 6px;
  padding: 6px;
}
div.note-sidebar > div.inner { background-image: none; }
div.note-sidebar > div.inner > div.title { margin-</xsl:text>
  <xsl:value-of select="$left"/><xsl:text>: 0px; }
div.note-sidebar > div.inner > div.region > div.contents { margin-</xsl:text>
  <xsl:value-of select="$left"/><xsl:text>: 0px; }
div.note-plain > div.inner { background-image: none; }
div.note-plain > div.inner > div.title { margin-</xsl:text>
  <xsl:value-of select="$left"/><xsl:text>: 0px; }
div.note-plain > div.inner > div.region > div.contents { margin-</xsl:text>
  <xsl:value-of select="$left"/><xsl:text>: 0px; }
div.quote {
  padding: 0;
  min-height: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
div.quote > div.inner:before {
  float: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  content: '</xsl:text>
  <xsl:variable name="quote">
    <xsl:for-each select="$node[1]">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'quote.format'"/>
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="quotc" select="substring(concat($quote, '“'), 1, 1)"/>
  <xsl:choose>
    <xsl:when test="contains('«‹', $quotc)">
      <xsl:text>«</xsl:text>
    </xsl:when>
    <xsl:when test="contains('»›', $quotc)">
      <xsl:text>»</xsl:text>
    </xsl:when>
    <xsl:when test="contains('”„’‚', $quotc)">
      <xsl:text>”</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>“</xsl:text>
    </xsl:otherwise>
  </xsl:choose><xsl:text>';
  font-family: "Century Schoolbook L";
  font-size: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
  font-weight: bold;
  line-height: </xsl:text>
  <xsl:choose>
    <xsl:when test="contains('«»‹›', $quotc)">
      <xsl:text>0.5</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>1</xsl:text>
    </xsl:otherwise>
  </xsl:choose><xsl:text>em;
  margin: 0; padding: 0;
  height: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
  width: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
  text-align: center;
  color: </xsl:text>
    <xsl:value-of select="$color.bg.dark"/><xsl:text>;
}
div.quote > div.inner > div.title {
  margin: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
blockquote {
  margin: 0; padding: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
}
blockquote > *:first-child { margin-top: 0; }
div.quote > div.inner > div.region > div.cite {
  margin-top: 0.5em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$icons.size.quote"/><xsl:text>px;
  color: </xsl:text><xsl:value-of select="$color.fg.gray"/><xsl:text>;
}
div.quote > div.inner > div.region > div.cite::before {
  <!-- FIXME: i18n -->
  content: '&#x2015; ';
  color: </xsl:text><xsl:value-of select="$color.fg.gray"/><xsl:text>;
}
div.screen {
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
ol.steps, ul.steps {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 4px </xsl:text>
    <xsl:value-of select="$color.yellow"/><xsl:text>;
  box-shadow: 0 1px 2px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
ol.steps .steps {
  padding: 0;
  border: none;
  background-color: none;
  box-shadow: none;
}
li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em; }
li.steps li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em; }
div.synopsis > div.inner > div.region > div.contents,
div.synopsis > div.contents, div.synopsis > pre.contents {
  padding: 0.5em 1em 0.5em 1em;
  border-top: solid 1px;
  border-bottom: solid 1px;
  border-color: </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
div.synopsis > div.inner > div.region > div.desc { font-style: italic; }
div.synopsis div.code {
  background: none;
  border: none;
  padding: 0;
}
div.synopsis div.code > pre.contents { margin: 0; padding: 0; }
div.table > div.desc { font-style: italic; }
tr.shade {
  background-color: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
td.shade {
  background-color: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
}
tr.shade td.shade {
  background-color: </xsl:text><xsl:value-of select="$color.bg.dark"/><xsl:text>;
}

span.app { font-style: italic; }
span.cmd {
  font-family: monospace;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
  padding: 0 0.2em 0 0.2em;
}
span.cmd span.cmd { background-color: none; padding: 0; }
pre span.cmd { background-color: none; padding: 0; }
span.code {
  font-family: monospace;
  border-bottom: solid 1px </xsl:text><xsl:value-of select="$color.bg.dark"/><xsl:text>;
}
span.code span.code { border: none; }
pre span.code { border: none; }
span.em { font-style: italic; }
span.em-bold {
  font-style: normal; font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
pre span.error {
  color: </xsl:text><xsl:value-of select="$color.fg.red"/><xsl:text>;
}
span.file { font-family: monospace; }
span.gui, span.guiseq { color: </xsl:text>
  <xsl:value-of select="$color.fg.dark"/><xsl:text>; }
span.input { font-family: monospace; }
pre span.input {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
kbd {
  font-family: inherit;
  font-size: inherit;
  color: </xsl:text>
    <xsl:value-of select="$color.fg.dark"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  -moz-border-radius: 2px;
  -webkit-border-radius: 2px;
  border-radius: 2px;
  box-shadow: 1px 1px 2px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  margin: 0 0.2em 0 0.2em;
  padding: 0.2em 0.5em 0 0.5em;
  white-space: nowrap;
}
kbd.key-Fn {
  font-weight: bold;
  color: </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
span.key a {
  border-bottom: none;
}
a > kbd {
  color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
  border-color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
span.keyseq {
  color: </xsl:text>
    <xsl:value-of select="$color.fg.dark"/><xsl:text>;
  white-space: nowrap
}
span.output { font-family: monospace; }
pre span.output {
  color: </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
}
pre span.prompt {
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
span.sys { font-family: monospace; }
span.var { font-style: italic; }

.ui-tile-img .media-controls { display: none; }
span.media-audio, span.media-video { display: inline-block; }
audio, video { display: block; margin: 0; }
div.media > div.inner { display: inline-block; text-align: center; }
div.media-controls {
  min-width: 24em;
  height: 24px;
  margin: 0; padding: 0;
  border-left: solid 1px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;;
  border-right: solid 1px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;;
  border-bottom: solid 1px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;;
  background-color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  color: </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
  border-bottom-left-radius: 4px;
  border-bottom-right-radius: 4px;
  display: flex;
  align-items: center;
}
.media-audio div.media-controls {
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
}
div.media-controls > * {
  flex: 0 1 auto;
}
div.media-controls > input.media-range {
  flex: 1 0 auto;
  background-color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  color: </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
  margin: 0 10px;
-webkit-appearance: none;
}
input.media-range::-webkit-slider-runnable-track {
  height: 8px;
  background: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
  border-radius: 2px;
}
div.media-controls-audio {
  border-top: solid 1px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;;
  border-radius: 4px;
}
button.media-play {
  height: 24px;
  padding: 0 2px 0 2px; line-height: 0;
  background-color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  border: none;
  border-</xsl:text><xsl:value-of select="$right"/><xsl:text>: solid 1px </xsl:text>
    <xsl:value-of select="$color.fg"/><xsl:text>;;
}
button.media-play:hover, button.media-play:focus {
  background-color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
button.media-play canvas { margin: 0; }
div.media-time {
  margin: 0;
  font-size: 16px;
  height: 24px;
  line-height: 24px;
}
div.media-time > span {
  padding-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 8px;
}
span.media-duration {
  font-size: 12px;
  color: </xsl:text><xsl:value-of select="$color.bg.dark"/><xsl:text>;
  opacity: 0.8;
}
div.media-ttml { margin: 0; padding: 0; }
.media-ttml-pre { white-space: pre; }
.media-ttml-nopre { white-space: normal; }
div.media-ttml-div {
  text-align: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  display: none;
  margin: 0; padding: 0;
}
div.media-ttml-p {
  text-align: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  display: none;
  margin: 6px auto 0 auto;
  padding: 6px;
  max-width: 24em;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.fg.yellow"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
  box-shadow: 2px 2px 4px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
div.yelp-data { display: none; }
.ui-expander > div.inner > div.title span.title,
.ui-expander > div.inner > div.hgroup span.title {
  cursor: default;
}
.ui-expander > div.inner > div.title span.title:before,
.ui-expander > div.inner > div.hgroup span.title:before {
  font-weight: bold;
  content: "⌃";
  display: inline-block;
  margin: 0;
  color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
  transform: translateY(0.2em) rotate(0deg);
  -webkit-transform: translateY(0.2em) rotate(0deg);
  transition: transform 0.2s linear;
  transform-origin: 50% 30%;
  -webkit-transform-origin: 50% 30%;
  -webkit-transition: -webkit-transform 0.2s linear;
  margin: 0 0.2em;
}
.ui-expander-c > div.inner > div.hgroup { border-bottom: none; }
.ui-expander-e > div.inner > div.title span.title:before,
.ui-expander-e > div.inner > div.hgroup span.title:before {</xsl:text>
<xsl:choose>
<xsl:when test="$direction = 'rtl'">
  transform: translateY(0.2em) rotate(-180deg);
  -webkit-transform: translateY(0.2em) rotate(-180deg);
</xsl:when>
<xsl:otherwise>
  transform: translateY(0.2em) rotate(180deg);
  -webkit-transform: translateY(0.2em) rotate(180deg);
</xsl:otherwise>
</xsl:choose><xsl:text>}
.ui-expander > div.inner > div.title:hover,
.ui-expander > div.inner > div.hgroup:hover * {
  color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
.ui-expander > div.inner > div.hgroup > .subtitle {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2em;
}
.ui-expander-c > div.inner > div.region {
  display: none;
}
.ui-expander-e > div.inner > div.region {
  animation-name: yelp-ui-expander-e;
  animation-duration: 0.2s;
  animation-fill-mode: forwards;
  transform-origin: 0 0;
}
@keyframes yelp-ui-expander-e {
  from { transform: scaleY(0); }
  to   { transform: scaleY(1); }
}

@media only screen and (max-width: 480px) {
  article > div.region > div.contents > div.example,
  article > div.region > section > div.inner > div.region > div.contents > div.example {
    margin-left: -10px;
    margin-right: -10px;
  }
  div.example {
    padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 6px;
    padding-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 10px;
  }
  article > div.region > div.contents > div.note,
  article > div.region > section > div.inner > div.region > div.contents > div.note {
    margin-left: -10px;
    margin-right: -10px;
    padding-left: 10px;
    padding-right: 10px;
  }
  article > div.region > div.contents > div.note,
  article > div.region > section > div.inner > div.region > div.contents > div.note {
    border-left: none;
    border-right: none;
  }
  div.note-sidebar {
    float: none;
    max-width: none;
    margin-left: inherit;
    margin-right: inherit;
    padding-left: inherit;
    padding-right: inherit;
  }
  div.note-sidebar > div.inner > div.title,
  div.note-sidebar > div.inner > div.region > div.contents {
    margin-left: 10px;
    margin-right: 10px;
  }
  article > div.region > div.contents > div.steps,
  article > div.region > section > div.inner > div.region > div.contents > div.steps {
    margin-left: -10px;
    margin-right: -10px;
  }
  div.steps > div.inner > div.title {
    margin-left: 10px;
    margin-right: 10px;
  }
  ol.steps, ul.steps {
    box-shadow: none;
    padding: 0;
    padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 6px;
    padding-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 10px;
  }
}
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.css.syntax
Output CSS for syntax highlighting.
:Revision: version="1.0" date="2010-12-06" status="final"
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS to support syntax highlighting of code blocks. Syntax
highlighting is done at document load time with JavaScript. Text in code blocks
is broken up into chunks and wrapped in HTML elements with particular classes.
This template outputs CSS to match those elements and style them with the
built-in themeable colors from !{color}.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.syntax">
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
  <xsl:if test="$html.syntax.highlight">
.hljs a {
  color: inherit;
  border-bottom: dotted 1px <xsl:value-of select="$color.fg.blue"/>;
}
.hljs a:hover, .hljs a:hover * { color: <xsl:value-of select="$color.fg.blue"/>; }
.hljs-addition {
  color: <xsl:value-of select="$color.fg.green"/>;
  background-color: <xsl:value-of select="$color.bg.green"/>;
}
.hljs-deletion {
  color: <xsl:value-of select="$color.fg.red"/>;
  background-color: <xsl:value-of select="$color.bg.red"/>;
}
.hljs-emphasis  { font-style: italic; }
.hljs-strong    { font-weight: bold; }
.hljs-attr      { color: <xsl:value-of select="$color.fg.blue"/>; }
.hljs-attribute { color: <xsl:value-of select="$color.fg.yellow"/>; }
.hljs-built_in  { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-bullet    { color: <xsl:value-of select="$color.fg.green"/>; }
.hljs-class     { }
.hljs-code      { }
.hljs-comment   { color: <xsl:value-of select="$color.fg.gray"/>; }
.hljs-doctag    { }
.hljs-formula   { color: <xsl:value-of select="$color.fg.dark"/>; }
.hljs-function  { }
.hljs-keyword   { color: <xsl:value-of select="$color.fg.purple"/>; }
.hljs-link      { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-literal   { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-meta      { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-name      { color: <xsl:value-of select="$color.fg.red"/>; }
.hljs-number    { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-params    { color: <xsl:value-of select="$color.fg.orange"/>; }
.hljs-quote     { color: <xsl:value-of select="$color.fg.gray"/>; }
.hljs-regexp    { color: <xsl:value-of select="$color.fg.red"/>; }
.hljs-rest_arg  { }
.hljs-section   { color: <xsl:value-of select="$color.fg.blue"/>; }
.hljs-string    { color: <xsl:value-of select="$color.fg.green"/>; }
.hljs-subst     { }
.hljs-symbol    { color: <xsl:value-of select="$color.fg.green"/>; }
.hljs-tag       { color: <xsl:value-of select="$color.fg.red"/>; }
.hljs-title     { color: <xsl:value-of select="$color.fg.blue"/>; }
.hljs-type      { }
.hljs-variable  { }
.hljs-selector-attr  { }
.hljs-selector-class { color: <xsl:value-of select="$color.fg.red"/>; }
.hljs-selector-id    { color: <xsl:value-of select="$color.fg.red"/>; }
.hljs-selector-tag   { color: <xsl:value-of select="$color.fg.purple"/>; }
.hljs-template-tag      { }
.hljs-template-variable { }
</xsl:if>
</xsl:template>


<!--**==========================================================================
html.css.custom
Stub to output custom CSS common to all HTML transformations.
:Stub: true
:Revision: version="1.0" date="2010-05-25" status="final"
$node: The node to create CSS for.
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template is a stub, called by *{html.css.content}. You can override this
template to provide additional CSS that will be used by all HTML output.
-->
<xsl:template name="html.css.custom">
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
</xsl:template>


<!--**==========================================================================
html.js
Output all JavaScript for an HTML output page.
:Revision:version="3.20" date="2016-01-18" status="final"
$node: The node to create JavaScript for.

This template creates the JavaScript for an HTML output page. It calls the
templates *{html.js.jquery}, *{html.js.syntax}, and *{html.js.mathjax} to
output references to external libraries. It then calls *{html.js.custom} to
output references to custom JavaScript files. Finally, it calls
*{html.js.script} to output local JavaScript created by *{html.js.content}.
-->
<xsl:template name="html.js">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.js.jquery">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.syntax">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.mathjax">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.custom">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.script">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.js.jquery
Output references to jQuery JavaScript files.
:Revision: version="1.0" date="2010-12-31" status="final"
$node: The node to create JavaScript for.

This template outputs HTML #{script} tags to reference any necessary jQuery files.
It always includes a reference to #{jquery.js}. If @{html.syntax.highlight} is
#{true}, it will also include a reference to #{jquery.syntax.js} along with an
additional #{script} tag to initialize syntax highlighting. All references are
output relative to @{html.js.root}.
-->
<xsl:template name="html.js.jquery">
  <xsl:param name="node" select="."/>
  <script type="text/javascript">
    <xsl:attribute name="src">
      <xsl:value-of select="$html.js.root"/>
      <xsl:text>jquery.js</xsl:text>
    </xsl:attribute>
  </script>
</xsl:template>


<!--**==========================================================================
html.js.mathjax
Output #{script} element to include MathJax.
:Revision: version="1.0" date="2012-11-13" status="final"
$node: The node to create JavaScript for.

This template outputs an HTML #{script} tag to reference MathJax. It only
outputs a #{script} element if ${node} has MathML descendent content. By
default, this template uses #{cnd.mathjax.org}. If you wish to use a local
copy, override this template and provide the necessary files.
-->
<xsl:template name="html.js.mathjax">
  <xsl:param name="node" select="."/>
  <xsl:if test="$node//mml:*[1]">
    <script type="text/javascript">
      <xsl:attribute name="src">
        <xsl:text>http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=MML_HTMLorMML</xsl:text>
      </xsl:attribute>
    </script>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
html.js.script
Output a JavaScript #{script} tag containing local content.
:Revision:version="3.20" date="2016-01-18" status="final"
$node: The node to create JavaScript for.

This template is called by *{html.js} to output JavaScript content. It outputs
a #{script} tag and calls *{html.js.content} to output the contents. To force
all JavaScript into external files, override this template to output a #{script}
tag referencing an external file with the #{src} attribute, then output the
result of *{html.js.content} to that file.
-->
<xsl:template name="html.js.script">
  <xsl:param name="node" select="."/>
  <script type="text/javascript">
    <xsl:call-template name="html.js.content">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </script>
</xsl:template>


<!--**==========================================================================
html.js.content
Output JavaScript content for an HTML output page.
:Revision:version="3.20" date="2016-01-18" status="final"
$node: The node to create JavaScript for.

This template is called by *{html.js.script} to output JavaScript content. It
does not output an HTML #{script} tag. The JavaScript output by this template
or templates it calls may depend on the jQuery code referenced by
*{html.js.jquery}. This template calls the templates *{html.js.core},
*{html.js.ui}, and *{html.js.media}. It then calls the mode %{html.js.mode}
on ${node} and calls the template *{html.js.content.custom}.
-->
<xsl:template name="html.js.content">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.js.core">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.ui">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.media">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:apply-templates mode="html.js.mode" select="$node"/>
  <xsl:call-template name="html.js.content.custom">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.js.core
Output JavaScript for core features.
:Revision: version="3.4" date="2011-11-04" status="final"
$node: The node to create JavaScript for.

This template outputs JavaScript to support basic features used by all documents.
Currently, it outputs code to highlight a section when #{location.hash} is set.
-->
<xsl:template name="html.js.core">
  <xsl:param name="node" select="."/>
<xsl:text>
document.addEventListener('DOMContentLoaded', function() {
  var yelp_hash_highlight = function () {
    if (location.hash != '') {
      var sect = document.querySelector(location.hash);
      if (sect != null) {
        sect.classList.add('yelp-hash-highlight');
        window.setTimeout(function () {
          sect.classList.remove('yelp-hash-highlight');
        }, 500);
      }
    }
  }
  window.addEventListener('hashchange', yelp_hash_highlight, false);
  yelp_hash_highlight();
}, false);
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.ui
Output JavaScript for UI extensions.
:Revision: version="1.0" date="2011-06-17" status="final"
$node: The node to create JavaScript for.

This template outputs JavaScript that implements certain common UI extensions,
such as expandable blocks and sections.
-->
<xsl:template name="html.js.ui">
  <xsl:param name="node" select="."/>
<xsl:text><![CDATA[
var __yelp_generate_id_counter__ = 0;
function yelp_generate_id () {
  var ret = 'yelp--' + (++__yelp_generate_id_counter__).toString();
  if (document.getElementById(ret) != null)
    return yelp_generate_id();
  else
    return ret;
};
function yelp_ui_expander_init (expander) {
  var yelpdata = null;
  var innerdiv = null;
  var region = null;
  var title = null;
  var title_e = null;
  var title_c = null;
  var titlespan = null;
  var issect = false;
  for (var i = 0; i < expander.children.length; i++) {
    var child = expander.children[i];
    if (child.classList.contains('yelp-data-ui-expander')) {
      yelpdata = child;
    }
    else if (child.classList.contains('inner')) {
      innerdiv = child;
    }
  }
  if (innerdiv == null) {
    return;
  }
  for (var i = 0; i < innerdiv.children.length; i++) {
    var child = innerdiv.children[i];
    if (child.classList.contains('region')) {
      region = child;
    }
    else if (child.classList.contains('title')) {
      title = child;
    }
    else if (child.classList.contains('hgroup')) {
      title = child;
      issect = true;
    }
  }
  if (region == null || title == null) {
    return;
  }
  if (!region.hasAttribute('id')) {
    region.setAttribute('id', yelp_generate_id());
  }
  title.setAttribute('aria-controls', region.getAttribute('id'));

  if (yelpdata != null) {
    for (var i = 0; i < yelpdata.children.length; i++) {
      var child = yelpdata.children[i];
      if (child.classList.contains('yelp-title-expanded')) {
        title_e = child;
      }
      else if (child.classList.contains('yelp-title-collapsed')) {
        title_c = child;
      }
    }
  }
  titlespan = title.querySelector('span.title');
  if (titlespan == null) {
    return;
  }
  if (title_e == null) {
    var node = document.createElement('div');
    node.className = 'yelp-title-expanded';
    node.innerHTML = titlespan.innerHTML;
    yelpdata.appendChild(node);
    title_e = node;
  }
  if (title_c == null) {
    var node = document.createElement('div');
    node.className = 'yelp-title-collapsed';
    node.innerHTML = titlespan.innerHTML;
    yelpdata.appendChild(node);
    title_c = node;
  }

  var ui_expander_toggle = function () {
    if (yelpdata.getAttribute('data-yelp-expanded') == 'false') {
      yelpdata.setAttribute('data-yelp-expanded', 'true');
      expander.classList.remove('ui-expander-e');
      expander.classList.add('ui-expander-c');
      region.setAttribute('aria-expanded', 'false');
      if (title_c != null)
        titlespan.innerHTML = title_c.innerHTML;
    }
    else {
      yelpdata.setAttribute('data-yelp-expanded', 'false');
      expander.classList.remove('ui-expander-c');
      expander.classList.add('ui-expander-e');
      region.setAttribute('aria-expanded', 'true');
      if (title_e != null)
        titlespan.innerHTML = title_e.innerHTML;
    }
  };
  expander.yelp_ui_expander_toggle = ui_expander_toggle;
  title.addEventListener('click', ui_expander_toggle, false);
  ui_expander_toggle();
}
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('.ui-expander');
  for (var i = 0; i < matches.length; i++) {
    yelp_ui_expander_init(matches[i]);
  }
  var yelp_hash_ui_expand = function () {
    if (location.hash != '') {
      var sect = document.querySelector(location.hash);
      if (sect != null) {
        for (var cur = sect; cur instanceof Element; cur = cur.parentNode) {
          if (cur.classList.contains('ui-expander')) {
            if (cur.classList.contains('ui-expander-c')) {
              cur.yelp_ui_expander_toggle();
            }
          }
        }
        sect.scrollIntoView();
      }
    }
  };
  window.addEventListener('hashchange', yelp_hash_ui_expand, false);
  yelp_hash_ui_expand();
}, false);
]]></xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.media
Output JavaScript to control media elements.
:Revision: version="1.0" date="2010-01-01" status="final"
$node: The node to create JavaScript for.

This template outputs JavaScript that controls media elements. It provides
control for audio and video elements as well as support for captions.
-->
<xsl:template name="html.js.media">
  <xsl:param name="node" select="."/>
<xsl:text><![CDATA[
yelp_color_text_light = ']]></xsl:text>
<xsl:value-of select="$color.fg.dark"/><xsl:text><![CDATA[';
yelp_color_gray_background = ']]></xsl:text>
<xsl:value-of select="$color.bg.gray"/><xsl:text><![CDATA[';
yelp_color_gray_border = ']]></xsl:text>
<xsl:value-of select="$color.gray"/><xsl:text><![CDATA[';
yelp_paint_zoom = function (zoom, zoomed) {
  var ctxt = zoom.children('canvas')[0].getContext('2d');
  ctxt.strokeStyle = ctxt.fillStyle = yelp_color_text_light;
  ctxt.clearRect(0, 0, 10, 10);
  ctxt.strokeRect(0.5, 0.5, 9, 9);
  if (zoomed) {
    ctxt.fillRect(1, 1, 9, 4);
    ctxt.fillRect(5, 5, 4, 4);
    zoom.attr('title', zoom.attr('data-zoom-out-title'));
  }
  else {
    ctxt.fillRect(1, 5, 4, 4);
    zoom.attr('title', zoom.attr('data-zoom-in-title'));
  }
}
$.fn.yelp_auto_resize = function () {
  var fig = $(this);
  if (fig.is('img'))
    fig = fig.parents('div.figure').eq(0);
  if (fig.data('yelp-zoom-timeout') != undefined) {
    clearInterval(fig.data('yelp-zoom-timeout'));
    fig.removeData('yelp-zoom-timeout');
  }
  var imgs = fig.find('img');
  for (var i = 0; i < imgs.length; i++) {
    var img = $(imgs[i]);
    if (img.data('yelp-load-bound') == true)
      img.unbind('load', fig.yelp_auto_resize);
    if (!imgs[i].complete) {
      img.data('yelp-load-bound', true);
      img.bind('load', fig.yelp_auto_resize);
      return false;
    }
  }
  $(window).unbind('resize', yelp_resize_imgs);
  var zoom = fig.children('div.inner').children('a.zoom');
  if (fig.find('div.contents:first').is(':hidden')) {
    zoom.hide();
    return;
  }
  for (var i = 0; i < imgs.length; i++) {
    var img = $(imgs[i]);
    if (img.data('yelp-original-width') == undefined) {
      var iwidth = parseInt(img.attr('width'));
      if (!iwidth)
        iwidth = img[0].width;
      img.data('yelp-original-width', iwidth);
      var iheight = parseInt(img.attr('height'));
      if (!iheight)
        iheight = img[0].height * (iwidth / img[0].width);
      img.data('yelp-original-height', iheight);
    }
    if (img.data('yelp-original-width') > img.parent().width()) {
      if (img.data('yelp-zoomed') != true) {
        img[0].width = img.parent().width();
        img[0].height = (parseInt(img.data('yelp-original-height')) *
                         img.width() / parseInt(img.data('yelp-original-width')));
      }
      zoom.show();
    }
    else {
      img[0].width = img.data('yelp-original-width');
      img[0].height = img.data('yelp-original-height');
      zoom.hide();
    }
  }
  /* The image scaling above can cause the window to resize if it causes
   * scrollbars to disappear or reapper. Unbind the resize handler before
   * scaling the image. Don't rebind immediately, because we'll still get
   * that resize event in an idle. Rebind on the callback instead.
   */
  var reresize = function () {
    $(window).unbind('resize', reresize);
    $(window).bind('resize', yelp_resize_imgs);
  }
  $(window).bind('resize', reresize);
  return false;
};
yelp_resize_imgs = function () {
  $('div.figure img').parents('div.figure').each(function () {
    var div = $(this);
    if (div.data('yelp-zoom-timeout') == undefined)
      div.data('yelp-zoom-timeout', setTimeout(function () { div.yelp_auto_resize() }, 1));
  });
  return false;
};
$(document).ready(function () {
  $('div.figure img').parents('div.figure').each(function () {
    var fig = $(this);
    var zoom = fig.children('div.inner').children('a.zoom');
    zoom.append($('<canvas width="10" height="10"/>'));
    yelp_paint_zoom(zoom, false);
    zoom.data('yelp-zoomed', false);
    zoom.click(function () {
      var zoomed = !zoom.data('yelp-zoomed');
      zoom.data('yelp-zoomed', zoomed);
      zoom.parent().find('img').each(function () {
        var zimg = $(this);
        zimg.data('yelp-zoomed', zoomed);
        if (zoomed) {
          zimg[0].width = zimg.data('yelp-original-width');
          zimg[0].height = zimg.data('yelp-original-height');
        } else {
          zimg[0].width = zimg.parent().width();
          zimg[0].height = (parseInt(zimg.data('yelp-original-height')) *
                            zimg.width() / parseInt(zimg.data('yelp-original-width')));
        }
        yelp_paint_zoom(zoom, zoomed);
      });
      return false;
    });
  });
  yelp_resize_imgs();
  $(window).bind('resize', yelp_resize_imgs);
});
function yelp_media_init (media) {
  media.removeAttribute('controls');
  media.addEventListener('click', function () {
    if (media.paused)
      media.play();
    else
      media.pause();
  }, false);

  var controls = document.createElement('div');
  controls.className = 'media-controls media-controls-' + media.nodeName;
  media.parentNode.insertBefore(controls, media.nextSibling);

  var playControl = document.createElement('button');
  playControl.className = 'media-play';
  playControl.setAttribute('data-play-label', media.getAttribute('data-play-label'));
  playControl.setAttribute('data-pause-label', media.getAttribute('data-pause-label'));
  playControl.setAttribute('value', media.getAttribute('data-play-label'));
  controls.appendChild(playControl);

  var playCanvas = document.createElement('canvas');
  playCanvas.setAttribute('width', '20');
  playCanvas.setAttribute('height', '20');
  playControl.appendChild(playCanvas);

  var rangeControl = document.createElement('input');
  rangeControl.className = 'media-range'
  rangeControl.setAttribute('type', 'range');
  rangeControl.value = 0;
  controls.appendChild(rangeControl);

  var curSpan = document.createElement('span');
  curSpan.className = 'media-current';
  curSpan.textContent = '0:00';
  var durSpan = document.createElement('span');
  durSpan.className = 'media-duration';
  durSpan.textContent = '-:--';
  var timeDiv = document.createElement('div');
  timeDiv.className = 'media-time';
  timeDiv.appendChild(curSpan);
  timeDiv.appendChild(durSpan);
  controls.appendChild(timeDiv);

  var playCanvasCtxt = playCanvas.getContext('2d');
  var paintPlayButton = function () {
    playCanvasCtxt.fillStyle = yelp_color_gray_background;
    playCanvasCtxt.clearRect(0, 0, 20, 20);
    playCanvasCtxt.beginPath();
    playCanvasCtxt.moveTo(5, 5);   playCanvasCtxt.lineTo(5, 15);
    playCanvasCtxt.lineTo(15, 10); playCanvasCtxt.lineTo(5, 5);
    playCanvasCtxt.fill();
  }
  var paintPauseButton = function () {
    playCanvasCtxt.fillStyle = yelp_color_gray_background;
    playCanvasCtxt.clearRect(0, 0, 20, 20);
    playCanvasCtxt.beginPath();
    playCanvasCtxt.moveTo(5, 5);   playCanvasCtxt.lineTo(9, 5);
    playCanvasCtxt.lineTo(9, 15);  playCanvasCtxt.lineTo(5, 15);
    playCanvasCtxt.lineTo(5, 5);   playCanvasCtxt.fill();
    playCanvasCtxt.beginPath();
    playCanvasCtxt.moveTo(11, 5);  playCanvasCtxt.lineTo(15, 5);
    playCanvasCtxt.lineTo(15, 15); playCanvasCtxt.lineTo(11, 15);
    playCanvasCtxt.lineTo(11, 5);  playCanvasCtxt.fill();
  }
  paintPlayButton();

  var mediaChange = function () {
    if (media.ended)
      media.pause()
    if (media.paused) {
      playControl.setAttribute('value', playControl.getAttribute('data-play-label'));
      paintPlayButton();
    }
    else {
      playControl.setAttribute('value', playControl.getAttribute('data-pause-label'));
      paintPauseButton();
    }
  }
  media.addEventListener('play', mediaChange, false);
  media.addEventListener('pause', mediaChange, false);
  media.addEventListener('ended', mediaChange, false);
  playControl.addEventListener('click', function () {
    if (media.paused || media.ended)
      media.play();
    else
      media.pause();
  }, false);

  var ttmlDiv = null;
  var ttmlNodes = null;
  for (var i = 0; i < media.parentNode.children.length; i++) {
    var child = media.parentNode.children[i];
    if (child.classList.contains('media-ttml'))
      ttmlDiv = child;
  }
  if (ttmlDiv != null) {
    ttmlNodes = ttmlDiv.querySelectorAll('.media-ttml-node');
  }

  var timeUpdate = function () {
    var pct = (media.currentTime / media.duration) * 100;
    rangeControl.value = pct;
    var mins = parseInt(media.currentTime / 60);
    var secs = parseInt(media.currentTime - (60 * mins))
    curSpan.textContent = (mins + (secs < 10 ? ':0' : ':') + secs);
    if (ttmlNodes != null) {
      for (var i = 0; i < ttmlNodes.length; i++) {
        var ttml = ttmlNodes[i];
        if (media.currentTime >= parseFloat(ttml.getAttribute('data-ttml-begin')) &&
            (!ttml.hasAttribute('data-ttml-end') ||
             media.currentTime < parseFloat(ttml.getAttribute('data-ttml-end')) )) {
          if (ttml.tagName == 'span' || ttml.tagName == 'SPAN')
            ttml.style.display = 'inline';
          else
            ttml.style.display = 'block';
        }
        else {
          ttml.style.display = 'none';
        }
      }
    }
  };
  media.addEventListener('timeupdate', timeUpdate, false);
  var durationUpdate = function () {
    if (!isNaN(media.duration)) {
      mins = parseInt(media.duration / 60);
      secs = parseInt(media.duration - (60 * mins));
      durSpan.textContent = (mins + (secs < 10 ? ':0' : ':') + secs);
    }
  };
  media.addEventListener('durationchange', durationUpdate, false);

  rangeControl.addEventListener('input', function () {
    var pct = this.value;
    if (pct < 0)
      pct = 0;
    if (pct > 100)
      pct = 100;
    media.currentTime = (pct / 100.0) * media.duration;
  }, false);
};
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('video, audio');
  for (var i = 0; i < matches.length; i++) {
    yelp_media_init(matches[i]);
  }
}, false);
]]></xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.syntax
Output #{script} elements for syntax highlighting.
:Revision: version="3.20" date="2016-01-03" status="final"
$node: The node to create JavaScript for.

This template outputs HTML #{script} elements to enable syntax highlighting.
It only outputs if @{html.syntax.highlight} is #{true}. It outputs one #{script}
element to load in #{highlight.js}, and another to initialize #{highlight.js}
on all #{code} elements with #{"syntax"} in the class value.
-->
<xsl:template name="html.js.syntax">
  <xsl:param name="node" select="."/>
  <xsl:if test="$html.syntax.highlight">
  <script type="text/javascript" src="highlight.pack.js"></script>
  <script><![CDATA[
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('code.syntax')
  for (var i = 0; i < matches.length; i++) {
    hljs.highlightBlock(matches[i]);
  }
}, false);]]></script>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
html.js.mode
Output JavaScript specific to the input format.
:Revision:version="1.0" date="2010-01-01" status="final"

This template is called by *{html.js.content} to output JavaScript specific to
the input format. Importing stylesheets may implement this for any element that
will be passed to *{html.page}. If they do not, the output HTML will only have
the common JavaScript.
-->
<xsl:template mode="html.js.mode" match="*">
</xsl:template>


<!--**==========================================================================
html.js.custom
Stub to reference custom JavaScript common to all HTML transformations.
:Stub: true
:Revision: version="1.0" date="2010-04-16" status="final"
$node: The node to create JavaScript for.

This template is a stub, called by *{html.js}. You can override this template
to reference additional external JavaScript files. If you want to include
JavaScript into the main #{script} tag instead, use *{html.js.content.custom}.
-->
<xsl:template name="html.js.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.js.content.custom
Stub to output custom JavaScript common to all HTML transformations.
:Stub: true
:Revision: version="1.0" date="2010-04-16" status="final"
$node: The node to create JavaScript for.

This template is a stub, called by *{html.js.content}. You can override this
template to provide additional JavaScript that will be used by all HTML output.
This template is called inside a #{script} tag, and is intended to include
JavaScript code in the output page. See *{html.js.custom} to include a custom
reference to an external JavaScript file.
-->
<xsl:template name="html.js.content.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.lang.attrs
Output #{lang} and #{dir} attributes.
:Revision: version="1.0" date="2010-06-10" status="final"
$node: The current element in the input document.
$parent: A parent node to take ${lang} and ${dir} from.
$lang: The language for ${node}.
$dir: The text directionality for ${node}.

This template outputs #{lang}, #{xml:lang}, or #{dir} attributes if necessary.
If ${lang} is not set, it will be taken from the #{xml:lang} or #{lang}
attribute of ${node}. If ${dir} is not set, it will be taken from the #{its:dir}
attribute of ${node} or computed based on ${lang}.

The ${parent} parameter defaults to an empty node set. If it is set to a
non-empty node set, this template will attempt to get ${lang} and ${dir} from
${parent} if they are not set on ${node}. This is occasionally useful when a
wrapper element in a source language doesn't directly create any output
elements.

This template outputs either an #{xml:lang} or a #{lang} attribute, depending
on whether @{html.xhtml} is #{true}. It only outputs an #{xml:lang} or #{lang}
attribute if $lang is non-empty. This template also outputs a #{dir} attribute
if ${dir} is non-empty.
-->
<xsl:template name="html.lang.attrs">
  <xsl:param name="node" select="."/>
  <xsl:param name="parent" select="/false"/>
  <xsl:param name="lang">
    <xsl:choose>
      <xsl:when test="$node/@xml:lang">
        <xsl:value-of select="$node/@xml:lang"/>
      </xsl:when>
      <xsl:when test="$node/@lang">
        <xsl:value-of select="$node/@lang"/>
      </xsl:when>
      <xsl:when test="$parent/@xml:lang">
        <xsl:value-of select="$parent/@xml:lang"/>
      </xsl:when>
      <xsl:when test="$parent/@lang">
        <xsl:value-of select="$parent/@lang"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="dir">
    <xsl:choose>
      <xsl:when test="$node/@its:dir">
        <xsl:value-of select="$node/@its:dir"/>
      </xsl:when>
      <xsl:when test="($node/@xml:lang or $node/@lang) and (string($lang) != '')">
        <xsl:call-template name="l10n.direction">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$parent/@its:dir">
        <xsl:value-of select="$node/@its:dir"/>
      </xsl:when>
      <xsl:when test="string($lang) != ''">
        <xsl:call-template name="l10n.direction">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:if test="string($lang) != ''">
    <xsl:choose>
      <xsl:when test="$html.xhtml">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="$lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="lang">
          <xsl:value-of select="$lang"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:if test="string($dir) != ''">
    <xsl:attribute name="dir">
      <xsl:value-of select="$dir"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
html.syntax.class
Output HTML class values for syntax highlighting.
:Revision:version="3.20" date="2016-01-03" status="final"
$node: The source element whose content will be syntax highlighted.

This template calls %{html.syntax.class.mode} on ${node}. If the result of that
mode is a suitable language identifier, it outputs appropriate CSS class names
to enable syntax highlighting. The output should be placed in the #{class}
attribute of a #{pre} or similar output element by the calling template.

Importing stylesheets should implement %{html.syntax.class.mode} for any source
elements that may be syntax highlighted, then call this template when building
the #{class} attribute for output elements.
-->
<xsl:template name="html.syntax.class">
  <xsl:param name="node" select="."/>
  <xsl:variable name="class">
    <xsl:apply-templates mode="html.syntax.class.mode" select="$node"/>
  </xsl:variable>
  <xsl:if test="normalize-space($class) != ''">
    <xsl:text>syntax language-</xsl:text>
    <xsl:value-of select="$class"/>
  </xsl:if>
</xsl:template>

<!--%%==========================================================================
html.syntax.class.mode
Get the syntax highlighting language for a source-specific element.
:Revision:version="3.20" date="2016-01-03" status="final"

This mode is called by *{html.syntax.class} on source elements that may have
syntax highlighted. This template should be implemented by importing stylesheets.
It should return a simple language identifier.
-->
<xsl:template mode="html.syntax.class.mode" match="*"/>

</xsl:stylesheet>
