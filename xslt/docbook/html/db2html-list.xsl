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
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Lists</doc:title>


<!-- == db2html.list.border_color ========================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.list.border_color</name>
  <purpose>
    The color of the border around list elements
  </purpose>
</parameter>

<xsl:param name="db2html.list.border_color" select="'black'"/>


<!-- == db2html.list.css =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.list.css</name>
  <purpose>
    Create CSS for the list elements
  </purpose>
</template>

<xsl:template name="db2html.list.css">
  <xsl:text>
    div[class~="list"] { margin-left: 0px; padding: 0px; margin-bottom: 1em; }
    div[class~="list"] dl dt { margin-left: 0em; }
    div[class~="list"] dl dd + dt { margin-top: 1em; }
    div[class~="list"] dl dd {
      margin-top: 0.5em;
      margin-left: 2em;
      margin-right: 1em;
    }
    div[class~="list"] ul { margin-left: 2em; padding-left: 0em; }
    div[class~="list"] ol { margin-left: 2em; padding-left: 0em; }
    div[class~="list"] ul li { margin-right: 1em; padding: 0em; }
    div[class~="list"] ol li { margin-right: 1em; padding: 0em; }
    div[class~="list"] li + li { margin-top: 0.5em; }
  </xsl:text>
</xsl:template>


<!-- == Quick Matchers ===================================================== -->

<!--
Not doing this for varlistentry/listitem because it adds a non-negligable
amount of processing time for non-trivial documents.  The default CSS for
dd elements has a negative top margin.
-->
<xsl:template match="itemizedlist/listitem/para[
              not(preceding-sibling::* or following-sibling::*)  and
              not(../preceding-sibling::listitem[count(*) != 1]) and
              not(../following-sibling::listitem[count(*) != 1]) ]">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>
<xsl:template match="orderedlist/listitem/para[
              not(preceding-sibling::* or following-sibling::*)  and
              not(../preceding-sibling::listitem[count(*) != 1]) and
              not(../following-sibling::listitem[count(*) != 1]) ]">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>


<!-- ======================================================================= -->
<!-- == itemizedlist ======================================================= -->

<!-- = itemizedlist = -->
<xsl:template match="itemizedlist">
  <div class="list">
    <div class="itemizedlist">
      <xsl:call-template name="db2html.anchor"/>
      <xsl:apply-templates select="*[name(.) != 'listitem']"/>
      <ul>
        <xsl:if test="@mark">
          <xsl:attribute name="style">
            <xsl:text>list-style-type: </xsl:text>
            <xsl:choose>
              <xsl:when test="@mark = 'bullet'">disc</xsl:when>
              <xsl:when test="@mark = 'box'">square</xsl:when>
              <xsl:otherwise><xsl:value-of select="@mark"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@spacing = 'compact'">
          <xsl:attribute name="compact">
            <xsl:value-of select="@spacing"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="listitem"/>
      </ul>
    </div>
  </div>
</xsl:template>

<!-- = itemizedlist/listitem = -->
<xsl:template match="itemizedlist/listitem">
  <li>
    <xsl:if test="@override">
      <xsl:attribute name="style">
        <xsl:text>list-style-type: </xsl:text>
        <xsl:choose>
          <xsl:when test="@override = 'bullet'">disc</xsl:when>
          <xsl:when test="@override = 'box'">square</xsl:when>
          <xsl:otherwise><xsl:value-of select="@override"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>


<!-- ======================================================================= -->
<!-- == orderedlist ======================================================== -->


<!-- == db2html.orderedlist.start ========================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.orderedlist.start</name>
  <purpose>
    Determine the starting number for an ordered list
  </purpose>
  <parameter>
    <name>node</name>
    <purpose>
      The <xmltag>orderedlist</xmltag> element
    </purpose>
  </parameter>
</template>

<xsl:template name="orderedlist.start">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="@continutation != 'continues'">1</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist"
                    select="preceding::orderedlist[1]"/>
      <xsl:choose>
        <xsl:when test="count($prevlist) = 0">1</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="prevlength" select="count($prevlist/listitem)"/>
          <xsl:variable name="prevstart">
            <xsl:call-template name="orderedlist.start">
              <xsl:with-param name="node" select="$prevlist"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- = orderedlist = -->
<xsl:template match="orderedlist">
  <xsl:variable name="start">
    <xsl:choose>
      <xsl:when test="@continuation = 'continues'">
        <xsl:call-template name="orderedlist.start"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- FIXME: auto-numeration for nested lists -->
  <div class="list">
    <div class="orderedlist">
      <xsl:call-template name="db2html.anchor"/>
      <xsl:apply-templates select="*[name(.) != 'listitem']"/>
      <ol>
        <xsl:if test="@numeration">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="@numeration = 'arabic'">1</xsl:when>
              <xsl:when test="@numeration = 'loweralpha'">a</xsl:when>
              <xsl:when test="@numeration = 'lowerroman'">i</xsl:when>
              <xsl:when test="@numeration = 'upperalpha'">A</xsl:when>
              <xsl:when test="@numeration = 'upperroman'">I</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$start != '1'">
          <xsl:attribute name="start">
            <xsl:value-of select="$start"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@spacing = 'compact'">
          <xsl:attribute name="compact">
            <xsl:value-of select="@spacing"/>
          </xsl:attribute>
        </xsl:if>
        <!-- FIXME: @inheritnum -->
        <xsl:apply-templates select="listitem"/>
      </ol>
    </div>
  </div>
</xsl:template>

<!-- = orderedlist/listitem = -->
<xsl:template match="orderedlist/listitem">
  <li>
    <xsl:if test="@override">
      <xsl:attribute name="value">
        <xsl:value-of select="@override"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>


<!-- ======================================================================= -->
<!-- == procedure ========================================================== -->

<!-- = procedure = -->
<xsl:template match="procedure">
  <div class="list">
    <div class="procedure">
      <xsl:call-template name="db2html.anchor"/>
      <xsl:apply-templates select="*[name(.) != 'step']"/>
      <xsl:choose>
        <xsl:when test="count(step) = 1">
          <ul>
            <xsl:apply-templates select="step"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <ol>
            <xsl:apply-templates select="step"/>
          </ol>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </div>
</xsl:template>

<!-- FIXME: Do something with @performance -->

<!-- = step = -->
<xsl:template match="step">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- = substeps = -->
<xsl:template match="substeps">
  <xsl:variable name="depth" select="count(ancestor::substeps)"/>
  <div class="substeps">
    <xsl:call-template name="db2html.anchor"/>
    <ol>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="$depth mod 3 = 0">a</xsl:when>
          <xsl:when test="$depth mod 3 = 1">i</xsl:when>
          <xsl:when test="$depth mod 3 = 2">1</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ol>
  </div>
</xsl:template>


<!-- ======================================================================= -->
<!-- == segmentedlist ====================================================== -->

<!-- FIXME: Implement tabular segmentedlists -->

<!-- = segmentedlist = -->
<xsl:template match="segmentedlist">
  <div class="segmentedlist">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="seglistitem"/>
  </div>
</xsl:template>

<!-- = seglistitem = -->
<xsl:template match="seglistitem">
  <xsl:param name="position" select="count(preceding-sibling::seglistitem) + 1"/>
  <div class="seglistitem">
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="($position mod 2) = 1">
            <xsl:value-of select="'odd'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'even'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<!-- = segtitle = -->
<xsl:template match="segtitle">
  <b>
    <xsl:apply-templates/>
    <xsl:text>: </xsl:text>
  </b>
</xsl:template>

<!-- = seg = -->
<xsl:template match="seg">
  <xsl:variable name="position" select="count(preceding-sibling::seg) + 1"/>
  <p>
    <xsl:if test="$position = 1">
      <xsl:attribute name="class">
        <xsl:text>segfirst</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="../../segtitle[position() = $position]"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<!-- ======================================================================= -->
<!-- == simplelist ========================================================= -->

<xsl:template match="simplelist">
  <xsl:choose>
    <xsl:when test="@type = 'inline'">
      <span class="simplelist">
        <xsl:call-template name="db2html.anchor"/>
        <xsl:for-each select="member">
          <xsl:if test="position() != 1">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </span>
    </xsl:when>
    <xsl:when test="@type = 'horiz'">
      <div class="list">
        <div class="simplelist">
          <xsl:call-template name="db2html.anchor"/>
          <table>
            <xsl:for-each select="member[position() mod ../@columns = 1]">
              <tr>
                <td>
                  <xsl:apply-templates select="."/>
                </td>
                <xsl:for-each select="following-sibling::member[
                              position() &lt; ../@columns]">
                  <td>
                    <xsl:apply-templates select="."/>
                  </td>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </table>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="list">
        <div class="simplelist">
          <xsl:call-template name="db2html.anchor"/>
          <xsl:variable name="rows" select="ceiling(count(member) div @columns)"/>
          <table>
            <xsl:for-each select="member[position() &lt;= $rows]">
              <tr>
                <td>
                  <xsl:apply-templates select="."/>
                </td>
                <xsl:for-each select="following-sibling::member[
                              position() mod $rows = 0]">
                  <td>
                    <xsl:apply-templates select="."/>
                  </td>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </table>
        </div>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = member = -->
<xsl:template match="member">
  <!-- Do something trivial, and rely on simplelist to do the rest -->
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

<!-- ======================================================================= -->
<!-- == variablelist ======================================================= -->

<xsl:template match="variablelist">
  <div class="list">
    <div class="variablelist">
      <xsl:call-template name="db2html.anchor"/>
      <xsl:apply-templates select="*[name(.) != 'varlistentry']"/>
      <dl>
        <xsl:apply-templates select="varlistentry"/>
      </dl>
    </div>
  </div>
</xsl:template>

<xsl:template match="varlistentry">
  <dt>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:for-each select="term">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </dt>
  <xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <dd>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="term">
  <xsl:call-template name="db2html.inline"/>
</xsl:template>

</xsl:stylesheet>
