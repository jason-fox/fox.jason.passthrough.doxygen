<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Doxygen Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
>

  <xsl:template match="/">
  	<root>
      <xsl:for-each select="doxygen/compounddef[@kind='namespace' and (innerclass or innernamespace)]">
        <xsl:sort select="@id"/>
        <xsl:variable name="id">
          <xsl:value-of select="@id"/>
        </xsl:variable>
        <namespaces>
          <xsl:copy-of select="."/>
          <classes>
            <xsl:for-each select="innerclass">
              <xsl:sort select="@refid"/>
              <xsl:variable name="refid">
                <xsl:value-of select="@refid"/>
              </xsl:variable>
              <xsl:copy-of select="//compounddef[@id=$refid and @kind='class']"/>
            </xsl:for-each>
           </classes>
           <enums>
            <xsl:for-each select="innerclass">
              <xsl:sort select="@refid"/>
              <xsl:variable name="refid">
                <xsl:value-of select="@refid"/>
              </xsl:variable>
              <xsl:copy-of select="//compounddef[@id=$refid and @kind='enum']"/>
            </xsl:for-each>
           </enums>
           <interfaces>
            <xsl:for-each select="innerclass">
              <xsl:sort select="@refid"/>
              <xsl:variable name="refid">
                <xsl:value-of select="@refid"/>
              </xsl:variable>
              <xsl:copy-of select="//compounddef[@id=$refid and @kind='interface']"/>
            </xsl:for-each>
           </interfaces>
        </namespaces>
      </xsl:for-each>
      <xsl:variable name="all-nons" as="node()*">
        <xsl:call-template name="all-nons"/>
      </xsl:variable>

      <namespaces>
        <compounddef id="globalns" kind="namespace" language="C++">
        <compoundname>Global</compoundname>
          <xsl:for-each select="$all-nons">
            <xsl:variable name="id">
              <xsl:value-of select="@id"/>
            </xsl:variable>
            
              <xsl:element name="innerclass">
                <xsl:attribute name="refid" select="$id"/>
                <xsl:value-of select="compoundname"/>
              </xsl:element>
          </xsl:for-each>
        </compounddef>          
        <classes>
          <xsl:copy-of select="$all-nons[@kind='class']"/>
        </classes>
        <enums>
          <xsl:copy-of select="all-nons[@kind='enum']"/>
        </enums>
        <interfaces>
          <xsl:copy-of select="all-nons[@kind='interface']"/>
        </interfaces>
      </namespaces>
  	</root>
  </xsl:template>

  <xsl:template name="all-nons" as="element()*">
    <xsl:for-each select="/doxygen/compounddef[@kind != 'namespace' and @kind != 'file' and @kind != 'dir']">
      <xsl:variable name="id">
        <xsl:value-of select="@id"/>
      </xsl:variable>
      <xsl:if test="empty(//innerclass[@refid = $id]/parent::node()[@kind != 'file'])">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  
</xsl:stylesheet>
