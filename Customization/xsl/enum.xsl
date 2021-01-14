<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Doxygen Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="dita-ot" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0">

  <!--
     Enumeration Overview
  -->
  <xsl:template match="compounddef" mode="enum">
    <topic domains="(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)" class="- topic/topic " props="doxygen">
      <xsl:attribute name="id">
        <xsl:value-of select="dita-ot:name-to-id(compoundname)"/>
      </xsl:attribute>
      <xsl:attribute name="outputclass">
        <xsl:text>enum</xsl:text>
      </xsl:attribute>
      <title class="- topic/title "><xsl:value-of select="concat('Enum ', replace(compoundname, '^.*::',''))"/></title>
      <titlealts class="- topic/titlealts ">
        <navtitle class="- topic/navtitle ">
          <xsl:value-of select="replace(compoundname, '^.*::','')"/>
        </navtitle>
        <searchtitle class="- topic/searchtitle ">
          <xsl:value-of select="replace(compoundname, '^.*::','')"/>
        </searchtitle>
      </titlealts>
      <body class="- topic/body " outputclass="java">
        <codeblock class="+ topic/pre pr-d/codeblock ">
          <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'2')"/>
          <xsl:value-of select="concat(@prot, ' enum ')"/>
          <b class="+ topic/ph hi-d/b "><xsl:value-of select="replace(compoundname,'^.*::','')"/></b>
        </codeblock>
        <xsl:value-of select="briefdescription"/>
        <xsl:if test="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable']">
          <!-- Enumeration Constants Summary -->
          <section class="- topic/section " outputclass="constants_summary">
            <title class="- topic/title " >
              <xsl:text>Enum constants</xsl:text>
            </title>
            <xsl:call-template name="add-constant-summary"/>
          </section>
        </xsl:if>
      </body>
    </topic>
  </xsl:template>

  <!--
    Constant Summary
  -->
  <xsl:template name="add-constant-summary">
    <ul class="- topic/ul ">
      <xsl:for-each select="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable']">
        <xsl:sort select="name"/>
        <xsl:variable name="constant" select="name"/>
        <li class="- topic/li ">
          <xsl:value-of select="$constant" />
          <xsl:if test="comment">
            <xsl:value-of select="concat (' - ',substring-before(comment,'.'),'.')"/>
          </xsl:if>
        </li>
     </xsl:for-each>
    </ul>
  </xsl:template>


</xsl:stylesheet>