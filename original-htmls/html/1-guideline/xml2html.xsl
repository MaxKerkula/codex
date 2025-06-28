<?xml version="1.0" encoding="utf-8"?>
<!-- $Id: xml2html.xsl 3899 2025-03-31 16:17:04Z tgraham $ -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
	xmlns:s="http://www.antennahouse.com/names/XSL/Sample"
        exclude-result-prefixes="html axf s"
>

<xsl:output omit-xml-declaration="yes" encoding="UTF-8" />

<xsl:template match="/">
 <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#xA;</xsl:text>
 <xsl:comment> &#x24;Id$ </xsl:comment>
 <xsl:text>&#xA;</xsl:text>
 <xsl:apply-templates />
</xsl:template>

<xsl:template match="s:sample">
 <html data-cat="{@cat}" data-order="{@order}" data-ver="6.3" lang="{$lang}">
  <xsl:apply-templates select="@prefix" />
  <xsl:text>&#xA;</xsl:text>
  <head>
   <!--<xsl:text>&#xA;</xsl:text>
       <xsl:apply-templates select="s:title" />-->
   <xsl:text>&#xA;</xsl:text>
   <title>Title</title>
   <xsl:text>&#xA;</xsl:text>
   <meta charset="UTF-8" />
   <xsl:text>&#xA;</xsl:text>
   <xsl:apply-templates select="s:keyword" />
   <xsl:text>&#xA;</xsl:text>
   <xsl:apply-templates select="@specification" />
   <xsl:text>&#xA;</xsl:text>
   <xsl:call-template name="stylesheet-links" />
   <xsl:apply-templates select="s:style" />
   <xsl:text>&#xA;</xsl:text>
  </head>
  <xsl:text>&#xA;</xsl:text>
  <body>
    <xsl:apply-templates select="@class" />
   <xsl:text>&#xA;</xsl:text>
   <xsl:call-template name="running-elements" />
   <xsl:text>&#xA;</xsl:text>
   <xsl:apply-templates select="s:title"/>
   <xsl:text>&#xA;</xsl:text>
   <xsl:apply-templates
       select="s:description |
               s:source |
               s:subtitle |
               html:h3" />
  </body>
 </html>
</xsl:template>

<xsl:template match="s:sample/@prefix">
  <xsl:attribute name="data-{local-name()}">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="s:sample/@specification">
  <meta name="specification" content="{.}" />
</xsl:template>

<xsl:template match="s:title">
  <xsl:if test="not(@lang) or @lang = $lang">
    <h1>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </h1>
  </xsl:if>
</xsl:template>


<xsl:template match="html:div/@class[. = 'example']">
  <xsl:attribute name="class">SampleBox TextSample</xsl:attribute>
</xsl:template>

<!--
<xsl:template match="s:title[count(../s:title) = 1]">
 <h1>
  <xsl:apply-templates />
 </h1>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="s:title[following-sibling::s:title]"
              mode="h1">
  <xsl:variable name="other-title"
                select="following-sibling::*[name() = 's:title'][1]" />
 <h1>
   <span lang="{@lang}"><xsl:apply-templates select="text() | *" /></span>
   <span lang="{$other-title/@lang}">
     <xsl:apply-templates select="$other-title/text() | $other-title/*" />
   </span>
 </h1>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="s:title[preceding-sibling::s:title]"
              mode="h1"/>
-->

<xsl:template
    match="s:subtitle">
   <xsl:if test="not(@lang) or @lang = $lang">
<h2>
   <xsl:apply-templates select="@* | text() | *" />
 </h2>
 <xsl:text>&#xA;</xsl:text>
   </xsl:if>
</xsl:template>

<!--<xsl:template match="s:subtitle">
 <h2>
  <xsl:apply-templates />
 </h2>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>-->

<xsl:template match="s:keyword[1]">
  <meta name="keywords">
    <xsl:attribute name="content">
      <xsl:text>Antenna House Formatter, CSS, Paged Media, formatting</xsl:text>
      <xsl:for-each select="../s:keyword">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="." />
      </xsl:for-each>
    </xsl:attribute>
  </meta>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="s:style">
 <style>
  <xsl:apply-templates />
 </style>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="s:description">
  <xsl:if test="not(@lang) or @lang = $lang">
    <div class="description">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </div>
    <xsl:text>&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="s:rule | s:property | s:value">
 <span class="{local-name()}">
  <xsl:apply-templates select="@*" />
  <xsl:apply-templates />
  </span>
</xsl:template>

<xsl:template match="html:*">
 <xsl:element name="{local-name()}">
  <xsl:apply-templates select="@*" />
  <xsl:apply-templates />
 </xsl:element>
</xsl:template>

<xsl:template match="s:source">
  <xsl:if test="not(@lang) or @lang = $lang">
    <div class="{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="*">
  <xsl:if test="not(@lang) or @lang = $lang">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="text() | *" />
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="@*">
  <xsl:copy-of select="." />
</xsl:template>

<!--<xsl:template match="*[@lang = 'ja']" priority="10" />-->

<!-- Named templates. -->

<!-- Links to CSS stylesheets. -->
<xsl:template name="stylesheet-links">
  <link rel="stylesheet" href="../../css/booklet-print-4th.css"/>
  <xsl:text>&#xA;</xsl:text>
  <link rel="stylesheet" href="../../css/booklet-page-{$lang}.css"/>
  <xsl:text>&#xA;</xsl:text>
  <link rel="stylesheet" href="../../css/css-sample-{$lang}.css"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- Elements to be used as 'running' elements. -->
<xsl:template name="running-elements">
  <div class="page-number-footer page-number-footer-right">
    <span class="title"/><span class="separator" />
    <span class="page-number" />
  </div>
  <div class="page-number-footer page-number-footer-left">
    <span class="page-number" /><span class="separator" />
    <span class="title" />
  </div>
</xsl:template>

</xsl:stylesheet>
