<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Doxygen Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                version="2.0">
  <!--
    Package Summary
  -->
  <xsl:template name="add-package-summary">
    <li class=" topic/li ">
      <xsl:call-template name="add-link" >
        <xsl:with-param name="type" select="'topic'" />
        <xsl:with-param name="href" select="concat('#', dita-ot:name-to-id(compoundname))" />
        <xsl:with-param name="text" select="compoundname" />
      </xsl:call-template>
      <xsl:if test="normalize-space(briefdescription)!=''">
        <xsl:value-of select="concat (' - ', briefdescription)"/>
      </xsl:if>
    </li>
  </xsl:template>
  <!--
     Package Overview
  -->
  <xsl:template match="compounddef" mode="package">
    <topic domains="(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)" xmlns:dita="http://dita-ot.sourceforge.net/ns/201007/dita-ot" class="- topic/topic " ditaarch:DITAArchVersion="1.3" props="doxygen">
      <xsl:attribute name="id">
        <xsl:value-of select="dita-ot:name-to-id(compoundname)"/>
      </xsl:attribute>
      <xsl:attribute name="outputclass">
        <xsl:text>package</xsl:text>
      </xsl:attribute>
      <title class="- topic/title ">Namespace <xsl:value-of select="compoundname"/></title>
      <titlealts class="- topic/titlealts ">
        <navtitle class="- topic/navtitle ">
          <xsl:value-of select="compoundname"/>
        </navtitle>
        <searchtitle class="- topic/searchtitle ">
          <xsl:value-of select="compoundname"/>
        </searchtitle>
      </titlealts>
      <body class="- topic/body " outputclass="java">
        <xsl:call-template name="add-brief-description"/>

        <xsl:if test="../classes/compounddef">
          <section class="- topic/section " outputclass="class_summary">
            <title class="- topic/title " >
              <xsl:text>Class Summary</xsl:text>
            </title>
            <ul class=" topic/ul ">
              <xsl:for-each select="../classes/compounddef">
                <xsl:sort select="name"/>
                <xsl:call-template name="add-items-list"/>
              </xsl:for-each>
            </ul>
          </section>
        </xsl:if>

         <!--xsl:if test="class[@exception='true']">
          <section class="- topic/section " outputclass="class_summary">
            <title class="- topic/title " >
              <xsl:text>Exception Summary</xsl:text>
            </title>
            <ul class=" topic/ul ">
              <xsl:for-each select="class[@exception='true']">
                <xsl:sort select="@name"/>
                <xsl:call-template name="add-items-list"/>
              </xsl:for-each>
            </ul>
          </section>
        </xsl:if-->
        <xsl:if test="../interfaces/compounddef">
           <section class="- topic/section " outputclass="interfaces_summary">
            <title class="- topic/title " >
              <xsl:text>Interface Summary</xsl:text>
            </title>
            <ul class=" topic/ul ">
              <xsl:for-each select="../interfaces/compounddef">
                <xsl:sort select="name"/>
                <xsl:call-template name="add-items-list"/>
              </xsl:for-each>
            </ul>
          </section>
        </xsl:if>
        <xsl:if test="../enums/compounddef">
           <section class="- topic/section " outputclass="enums_summary">
            <title class="- topic/title " >
              <xsl:text>Enumeration Summary</xsl:text>
            </title>
            <ul class=" topic/ul ">
              <xsl:for-each select="../enums/compounddef">
                <xsl:sort select="name"/>
                <xsl:call-template name="add-items-list"/>
              </xsl:for-each>
            </ul>
          </section>
        </xsl:if>
      </body>
      <xsl:apply-templates select="../classes/compounddef" mode="class" >
        <xsl:sort select="compoundname" />
      </xsl:apply-templates>
      <xsl:apply-templates select="../interfaces/compounddef" mode="interface" >
        <xsl:sort select="compoundname" />
      </xsl:apply-templates>
      <xsl:apply-templates select="../enums/compounddef" mode="enum" >
        <xsl:sort select="compoundname" />
      </xsl:apply-templates>
    </topic>
  </xsl:template>
  <!--
    Summary listing for Classes, Interfaces and Enumeration
  -->
  <xsl:template name="add-items-list">
    <li class=" topic/li ">
      <xsl:call-template name="add-link" >
        <xsl:with-param name="type" select="'topic'" />
        <xsl:with-param name="href" select="concat('#', dita-ot:name-to-id(compoundname))" />
        <xsl:with-param name="text" select="replace(compoundname, '^.*::','')" />
      </xsl:call-template>
      <xsl:if test="normalize-space(briefdescription)!=''">
        <xsl:value-of select="concat (' - ', briefdescription)"/>
      </xsl:if>
    </li>
  </xsl:template>
</xsl:stylesheet>