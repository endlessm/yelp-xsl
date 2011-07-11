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
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:cache="http://projectmallard.org/cache/1.0/"
                xmlns:gloss="http://projectmallard.org/experimental/gloss/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal cache gloss exsl str"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Glossaries
Support the Mallard Glossary extension.

This stylesheet contains templates and supporting JavaScript to support the
Mallard Glossary extension in HTML.
-->


<!--**==========================================================================
mal2html.gloss.terms
Display the glossary terms for a page or section.
$node: The glossary #{page} or #{section} to output terms for.

This template shows the glossary terms for a page or section. It collects the
terms with the *{mal.gloss.terms} template, sorts them, and merges terms with
the same primary title. Terms that are not defined in the same page as ${node}
include a link to their defining page.
-->
<xsl:template name="mal2html.gloss.terms">
  <xsl:param name="node" select="."/>
  <xsl:variable name="pageid" select="$node/ancestor-or-self::mal:page[1]/@id"/>
  <xsl:variable name="terms_">
    <xsl:call-template name="mal.gloss.terms">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="terms" select="exsl:node-set($terms_)/gloss:term"/>
  <xsl:if test="count($terms) > 0">
    <dl class="list gloss-list">
      <xsl:for-each select="$terms">
        <xsl:sort select="normalize-space(mal:title[1])"/>
        <xsl:for-each select="mal:title">
          <dt class="gloss-term">
            <xsl:apply-templates mode="mal2html.inline.mode" select="node()"/>
          </dt>
        </xsl:for-each>
        <xsl:for-each select="gloss:term">
          <xsl:sort data-type="number" select="number(boolean(*[not(self::mal:title)]))"/>
          <xsl:sort data-type="number" select="number(not(ancestor::mal:page[1]/@id = $pageid))"/>
          <xsl:if test="not(@xref = $pageid)">
            <dd class="gloss-link">
              <a>
                <xsl:attribute name="href">
                  <xsl:call-template name="mal.link.target">
                    <xsl:with-param name="xref" select="@xref"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:call-template name="mal.link.tooltip">
                    <xsl:with-param name="xref" select="@xref"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:call-template name="mal.link.content">
                  <xsl:with-param name="node" select="."/>
                  <xsl:with-param name="xref" select="@xref"/>
                  <xsl:with-param name="role" select="'gloss:page'"/>
                </xsl:call-template>
              </a>
            </dd>
          </xsl:if>
          <xsl:if test="*[not(self::mal:title)]">
            <dd class="gloss-def">
              <xsl:apply-templates mode="mal2html.block.mode"
                                   select="*[not(self::mal:title)]"/>
            </dd>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </dl>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal2html.inline.mode" match="gloss:term">
  <xsl:variable name="node" select="."/>
  <span class="gloss-term">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
    <xsl:for-each select="$mal.cache">
      <xsl:variable name="terms" select="key('mal.gloss.key', $node/@ref)"/>
      <xsl:for-each select="$terms/mal:info/mal:desc[1]">
        <span class="gloss-desc">
          <xsl:apply-templates mode="mal2html.inline.mode"/>
        </span>
      </xsl:for-each>
    </xsl:for-each>
  </span>
</xsl:template>


<!--**==========================================================================
mal2html.gloss.js

REMARK: FIXME
-->
<xsl:template name="mal2html.gloss.js">
<xsl:text><![CDATA[
$(document).ready(function () {
  $('span.gloss-term').hover(
    function () {
      var top = $(this).offset().top + $(this).height() + 1;
      var left = $(this).offset().left;
      var desc = $(this).children('span.gloss-desc');
      var cnt = $(this).closest('div.contents');
      var diff = cnt.offset().left + cnt.width() - desc.width() - 4;
      if (left > diff)
        left = diff;
      desc.css({'top': top + 'px', 'left': left + 'px'}).fadeIn('slow');
    },
    function () {
      $(this).children('span.gloss-desc').fadeOut('fast');
    }
  );
});
]]></xsl:text>
</xsl:template>

</xsl:stylesheet>
