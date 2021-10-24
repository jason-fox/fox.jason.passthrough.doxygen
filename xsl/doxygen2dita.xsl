<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Doxygen Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  exclude-result-prefixes="dita-ot"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  version="3.0"
>
  
  <xsl:param name="output.dir.uri"/>

  <xsl:include href="../Customization/xsl/class.xsl"/>
  <xsl:include href="../Customization/xsl/enum.xsl"/>
  <xsl:include href="../Customization/xsl/html-processing.xsl"/>
  <xsl:include href="../Customization/xsl/interface.xsl"/>
  <xsl:include href="../Customization/xsl/method.xsl"/>
  <xsl:include href="../Customization/xsl/package.xsl"/>

  <!--
     Overall API Reference listing.
  -->
  <xsl:template match="/">
    <topic
      id="sample"
      domains="(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)"
      class="- topic/topic "
      props="doxygen"
    >
      <title class="- topic/title ">API Reference</title>
      <body class="- topic/body ">
        <section class="- topic/section ">
          <title class="- topic/title ">Namespaces</title>
          <ul class="- topic/ul ">
          <xsl:for-each select="//namespaces/compounddef">
            <xsl:sort select="compoundname"/>
            <xsl:call-template name="add-package-summary"/>
          </xsl:for-each>
          </ul>
        </section>
      </body>
      <xsl:apply-templates select="//namespaces/compounddef" mode="package">
        <xsl:sort select="compoundname"/>
      </xsl:apply-templates>
    </topic>
  </xsl:template>
  <!--
    Add a brief description if one is present.
  -->
  <xsl:template name="add-brief-description">
    <xsl:if test="normalize-space(briefdescription)!=''">
      <xsl:call-template name="parse-brief-description"/>
    </xsl:if>
  </xsl:template>

  <!--
    Add a detailed description if one is present.
  -->
  <xsl:template name="add-detailed-description">
    <xsl:if test="normalize-space(detaileddescription)!=''">
      <xsl:call-template name="parse-detailed-description"/>
    </xsl:if>
  </xsl:template>


  
  <!--
    Formatted description
  -->
  <xsl:template name="parse-brief-description">
    <xsl:variable name="html-fragment">
      <xsl:try>
        <xsl:copy>
          <xsl:copy-of select="parse-xml-fragment(concat('&lt;root&gt;',briefdescription,'&lt;/root&gt;'))"/>
        </xsl:copy>
        <xsl:catch>
          <xsl:copy>
            <xsl:copy-of
              select="parse-xml-fragment(concat('&lt;root&gt;',replace(briefdescription,'&lt;p&gt;','&#10;&#10;'),'&lt;/root&gt;'))"
            />
          </xsl:copy>
        </xsl:catch>
      </xsl:try>
    </xsl:variable>
    <xsl:apply-templates select="$html-fragment" mode="html"/>
  </xsl:template>

   <xsl:template name="parse-detailed-description">
    <xsl:apply-templates select="detaileddescription" mode="html"/>
  </xsl:template>

  <!--
    Add an internal cross reference
  -->
  <xsl:template name="add-link">
    <xsl:param name="type"/>
    <xsl:param name="href"/>
    <xsl:param name="text"/>

    <xref class="- topic/xref " format="dita" scope="local">
      <xsl:attribute name="type">
        <xsl:value-of select="$type"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
      <xsl:processing-instruction name="ditaot">
        <xsl:text>usertext</xsl:text>
      </xsl:processing-instruction>
      <xsl:value-of select="$text"/>
    </xref>
  </xsl:template>

  <!--
    Add a full width table consisting of a header 
    and a single row.
  -->
  <xsl:template name="mini-table">
    <xsl:param name="header"/>
    <xsl:param name="body"/>
    <tgroup class="- topic/tgroup " cols="1">
      <colspec class="- topic/colspec " colname="c1" colnum="1" colwidth="100%"/>
      <thead class="- topic/thead ">
        <row class="- topic/row ">
          <entry class="- topic/entry " colname="c1" align="left">
            <xsl:copy-of select="$header"/>
          </entry>
        </row>
      </thead>
      <tbody class="- topic/tbody ">
         <row class="- topic/row ">
          <entry class="- topic/entry " colname="c1" align="left">
            <xsl:copy-of select="$body"/>
          </entry>
        </row>
      </tbody>
    </tgroup>
  </xsl:template>


  <xsl:function name="dita-ot:name-to-id">
    <xsl:param name="name" as="xs:string"/>
    <xsl:value-of select="replace($name,'::','.')"/>
  </xsl:function>


  <xsl:function name="dita-ot:prismjs">
    <xsl:param name="language" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$language='Unknown'">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="$language='IDL'">
        <xsl:value-of select="'idl'"/>
      </xsl:when>
      <xsl:when test="$language='C#'">
        <xsl:value-of select="'csharp'"/>
      </xsl:when> 
      <xsl:when test="$language='Objective-C'">
        <xsl:value-of select="'objectivec'"/>
      </xsl:when>
      <xsl:when test="$language='C++'">
        <xsl:value-of select="'cpp'"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="lower-case($language)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
