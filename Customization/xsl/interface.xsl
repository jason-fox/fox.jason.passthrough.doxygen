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
  version="2.0"
>
  <!--
     Interface Overview
  -->
  <xsl:template match="compounddef" mode="interface">
    <topic
      domains="(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)"
      class="- topic/topic "
      props="doxygen"
    >
      <xsl:attribute name="id">
        <xsl:value-of select="dita-ot:name-to-id(compoundname)"/>
      </xsl:attribute>
      <xsl:attribute name="outputclass">
        <xsl:text>interface</xsl:text>
      </xsl:attribute>
      <title class="- topic/title "><xsl:value-of
          select="concat('Interface ',replace(compoundname, '^.*::',''))"
        /></title>
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
          <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'7')"/>
          <xsl:value-of select="concat(@prot, ' interface ')"/>
          <b class="+ topic/ph hi-d/b ">
          	<xsl:variable name="class" select="replace(compoundname, '^.*::','')"/>
		        <xsl:call-template name="add-type-link">
		          <xsl:with-param name="type" select="$class"/>
		        </xsl:call-template>
        	</b>
        </codeblock>
        <xsl:value-of select="briefdescription"/>
      
        <xsl:if test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and  not(type='')]">
          <!-- Interface Method Summary -->
          <section class="- topic/section " outputclass="methods_summary">
            <title class="- topic/title ">
            	<xsl:text>Method Summary</xsl:text>
            </title>
            <xsl:call-template name="add-method-summary"/>
          </section>
        </xsl:if>
     
        <xsl:if test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and  not(type='')]">
          <!-- Interface Method Details -->
          <section class="- topic/section " outputclass="methods">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(@qualified, '_methods')"/>
            </xsl:attribute>
            <title class="- topic/title ">
            	<xsl:text>Method Detail</xsl:text>
            </title>
            <xsl:apply-templates
              select="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and  not(type='')]"
              mode="method"
            >
              <xsl:sort select="name"/>
            </xsl:apply-templates>
           </section>
        </xsl:if>
      </body>
    </topic>
  </xsl:template>
</xsl:stylesheet>
