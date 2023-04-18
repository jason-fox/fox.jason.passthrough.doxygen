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
     Class Overview
  -->
  <xsl:template match="compounddef" mode="class">
    <topic
      domains="(topic abbrev-d) a(props deliveryTarget) (topic equation-d) (topic hazard-d) (topic hi-d) (topic indexing-d) (topic markup-d) (topic mathml-d) (topic pr-d) (topic relmgmt-d) (topic sw-d) (topic svg-d) (topic ui-d) (topic ut-d) (topic markup-d xml-d)"
      class="- topic/topic "
      props="doxygen"
    >
      <xsl:attribute name="id">
        <xsl:value-of select="dita-ot:name-to-id(compoundname)"/>
      </xsl:attribute>
      <xsl:attribute name="outputclass">
        <xsl:text>class</xsl:text>
      </xsl:attribute>
      <title class="- topic/title "><xsl:value-of select="concat ('Class ',replace(compoundname, '^.*::',''))"/></title>
      <titlealts class="- topic/titlealts ">
        <navtitle class="- topic/navtitle ">
          <xsl:value-of select="replace(compoundname, '^.*::','')"/>
        </navtitle>
        <searchtitle class="- topic/searchtitle ">
          <xsl:value-of select="replace(compoundname, '^.*::','')"/>
        </searchtitle>
      </titlealts>
      <body class="- topic/body ">
        <xsl:attribute name="outputclass">
            <xsl:value-of select="dita-ot:prismjs(@language)"/>
        </xsl:attribute>

        <xsl:if test="basecompoundref/@refid">
          <xsl:if test="starts-with(basecompoundref/@refid, 'interface')">
            <p class="- topic/p ">
              <b class="+ topic/ph hi-d/b ">
                <xsl:text>All Implemented Interfaces:</xsl:text>
              </b>
            </p>
            <ul class="- topic/ul ">
              <xsl:for-each select="basecompoundref">
                <li class="- topic/li ">
                  <xsl:call-template name="add-link">
                    <xsl:with-param name="type" select="'topic'"/>
                    <xsl:with-param name="href" select="concat('#', .)"/>
                    <xsl:with-param name="text" select="."/>
                  </xsl:call-template>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </xsl:if>
        <xsl:if test="derivedcompoundref">
          <p class="- topic/p ">
            <b class="+ topic/ph hi-d/b ">
              <xsl:text>Direct Known Subclasses:</xsl:text>
            </b>
          </p>
          <ul class="- topic/ul ">
            <xsl:for-each select="derivedcompoundref">
               <li class="- topic/li ">
                <xsl:call-template name="add-link">
                  <xsl:with-param name="type" select="'topic'"/>
                  <xsl:with-param name="href" select="concat('#', encode-for-uri(.))"/>
                  <xsl:with-param name="text" select="."/>
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>

        <codeblock class="+ topic/pre pr-d/codeblock ">
          <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'1')"/>
          <xsl:value-of select="concat(@prot, ' class ')"/>
          <b class="+ topic/ph hi-d/b "><xsl:value-of select="replace(compoundname,'^.*::','')"/></b>
          <xsl:choose>
            <xsl:when test="basecompoundref/@refid and //compounddef[@id=@refid]/compoundname">
              <xsl:text> extends </xsl:text>
             
              <xsl:for-each select="basecompoundref">
                <xsl:variable name="extends" select="@refid"/>
                <xsl:variable name="extends-name" select="//compounddef[@id=$extends]/compoundname"/>
                <xsl:if test="$extends-name">
                  
                <xsl:call-template name="add-link">
                  <xsl:with-param name="type" select="'topic'"/>
                  <xsl:with-param
                    name="href"
                      select="concat('#',   dita-ot:name-to-id($extends-name))"
                  />
                  <xsl:with-param name="text" select="replace(.,'^.*\.','')"/>
                </xsl:call-template>
                </xsl:if>
                <xsl:if test="count(basecompoundref) &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="basecompoundref">
              <xsl:value-of select="concat(' extends ', basecompoundref)"/>
            </xsl:when>
          </xsl:choose>
        </codeblock>
        <xsl:call-template name="parse-brief-description"/>
        <xsl:call-template name="parse-detailed-description"/>

        <xsl:if test="sectiondef/memberdef[@kind='typedef' and @prot='public']">
          <!-- Class typedef Summary -->
          <section class="- topic/section " outputclass="typedefs_summary">
            <title class="- topic/title ">
              <xsl:text>Types Summary</xsl:text>
            </title>
            <xsl:call-template name="add-typedefs-summary"/>
          </section>
        </xsl:if>
        <xsl:if test="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable' and @prot='public']">
          <!-- Class Field Summary -->
          <section class="- topic/section " outputclass="fields_summary">
            <title class="- topic/title ">
               <xsl:text>Field Summary</xsl:text>
             </title>
            <xsl:call-template name="add-field-summary"/>
          </section>
        </xsl:if>
        <xsl:if test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and type='' and @prot='public']">
          <!-- Class Constructor Summary -->
          <section class="- topic/section " outputclass="contructors_summary">
            <title class="- topic/title ">
               <xsl:text>Constructor Summary</xsl:text>
             </title>
            <xsl:call-template name="add-constructor-summary"/>
          </section>
        </xsl:if>
        <!-- Class Method Summary -->
         <section class="- topic/section " outputclass="methods_summary">
          <title class="- topic/title ">
             <xsl:text>Method Summary</xsl:text>
           </title>
          <xsl:if
            test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and not(type='') and @prot='public']"
          >
            <xsl:call-template name="add-method-summary"/>
          </xsl:if>
          <xsl:call-template name="add-inherited-method-summary"/>
        </section>

         <xsl:if test="sectiondef/memberdef[@kind='typedef'and @prot='public']">
          <!-- typedef Detail -->
          <section class="- topic/section " outputclass="typedefs">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(compoundname, '_typedefs')"/>
            </xsl:attribute>
            <title class="- topic/title ">
              <xsl:text>Types Detail</xsl:text>
            </title>
            <xsl:apply-templates
              select="sectiondef/memberdef[@kind='typedef' and @prot='public']"
              mode="typedef"
            >
              <xsl:sort select="@id"/>
            </xsl:apply-templates>
          </section>
        </xsl:if>


         <xsl:if test="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable'and @prot='public']">
          <!-- field Detail -->
          <section class="- topic/section " outputclass="fields">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(compoundname, '_fields')"/>
            </xsl:attribute>
            <title class="- topic/title ">
              <xsl:text>Field Detail</xsl:text>
            </title>
            <xsl:apply-templates
              select="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable' and @prot='public']"
              mode="field"
            >
              <xsl:sort select="@id"/>
            </xsl:apply-templates>
          </section>
        </xsl:if>

        <xsl:if test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and type='' and @prot='public']">
          <!-- Constructor Detail -->
          <section class="- topic/section " outputclass="constructors">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(compoundname, '_constructors')"/>
            </xsl:attribute>
            <title class="- topic/title ">
              <xsl:text>Constructor Detail</xsl:text>
            </title>
            <xsl:apply-templates
              select="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and type='' and @prot='public']"
              mode="constructor"
            >
              <xsl:sort select="name"/>
            </xsl:apply-templates>
          </section>
        </xsl:if>

        <xsl:if
          test="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and  not(type='') and @prot='public']"
        >
          <!-- Method Detail-->
          <section class="- topic/section " outputclass="methods">
            <xsl:attribute name="id">
              <xsl:value-of select="concat(compoundname, '_methods')"/>
            </xsl:attribute>
            <title class="- topic/title ">
              <xsl:text>Method Detail</xsl:text>
            </title>
            <xsl:apply-templates
              select="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and not(type='') and @prot='public']"
              mode="method"
            >
              <xsl:sort select="name"/>
            </xsl:apply-templates>
          </section>
        </xsl:if>
      </body>
    </topic>
  </xsl:template>

  <!--
    Constructor Summary
  -->
  <xsl:template name="add-constructor-summary">
    <table class="- topic/table " outputclass="constructor_summary">
      <tgroup class="- topic/tgroup " cols="1">
        <colspec class="- topic/colspec " colname="c1" colnum="1" colwidth="100%"/>
        <thead class="- topic/thead ">
          <row class="- topic/row ">
            <entry class="- topic/entry " colname="c1" align="left">
               <xsl:text>Constructor and Description</xsl:text>
            </entry>
          </row>
        </thead>
        <tbody class="- topic/tbody ">
          <xsl:for-each
            select="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and type='' and @prot='public']"
          >
            <xsl:sort select="name"/>
            <xsl:variable name="constructor" select="name"/>
            <row class="- topic/row ">
               <entry class="- topic/entry " colname="c1" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'1')"/>
                  <xsl:call-template name="add-link">
                    <xsl:with-param name="type" select="'table'"/>
                    <xsl:with-param name="href">
                      <xsl:value-of
                        select="concat('#', dita-ot:name-to-id(ancestor::compounddef/compoundname), '/constructors_', $constructor)"
                      />
                      <xsl:if test="count(../memberdef[name=$constructor])&gt;1">
                        <xsl:value-of select="count(following-sibling::memberdef[name=$constructor])"/>
                      </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$constructor"/>
                  </xsl:call-template>
                  <xsl:call-template name="add-signature"/>
                </codeph>
                <xsl:if test="normalize-space(briefdescription)!=''">
                  <xsl:value-of select="concat (' - ', briefdescription)"/>
                </xsl:if>
              </entry>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>

  <!--
      Constructor Details
  -->
  <xsl:template match="memberdef" mode="constructor">
    <xsl:variable name="constructor" select="name"/>
    <xsl:variable name="constructor_details">
      <codeblock class="+ topic/pre pr-d/codeblock ">
        <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'9')"/>
        <xsl:value-of select="$constructor"/>
        <xsl:call-template name="add-signature"/>
      </codeblock>
      <xsl:call-template name="parse-brief-description"/>
      <xsl:choose>
          <xsl:when test="detaileddescription/node()">
          <xsl:call-template name="parse-detailed-description"/>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="parameter-description"/>
    </xsl:variable>

    <table class="- topic/table " outputclass="constructor_details">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('constructors_',$constructor)"/>
        <xsl:if test="count(../memberdef[name=$constructor])&gt;1">
          <xsl:value-of select="count(following-sibling::memberdef[name=$constructor])"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="mini-table">
        <xsl:with-param name="header">
          <xsl:value-of select="$constructor"/>
        </xsl:with-param>
        <xsl:with-param name="body" select="$constructor_details"/>
      </xsl:call-template>
    </table>
    <p class="- topic/p "/>
  </xsl:template>

  <!--
    Field Summary
  -->
  <xsl:template name="add-field-summary">
    <table class="- topic/table " outputclass="field_summary">
      <tgroup class="- topic/tgroup " cols="2">
        <colspec class="- topic/colspec " colname="c1" colnum="1" colwidth="25%"/>
        <colspec class="- topic/colspec " colname="c2" colnum="2" colwidth="75%"/>
        <thead class="- topic/thead ">
          <row class="- topic/row ">
            <entry class="- topic/entry " colname="c1" align="left">
               <xsl:text>Modifier and Type</xsl:text>
            </entry>
            <entry class="- topic/entry " colname="c2" align="left">
               <xsl:text>Field and Description</xsl:text>
            </entry>
          </row>
        </thead>
        <tbody class="- topic/tbody ">
          <xsl:for-each select="sectiondef[contains(@kind,'-attrib')]/memberdef[@kind='variable' and @prot='public']">
            <xsl:sort select="name"/>
            <xsl:variable name="field" select="name"/>
            <row class="- topic/row ">
              <entry class="- topic/entry " colname="c1" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'3')"/>
                  <xsl:call-template name="add-modifiers"/>
                  <xsl:call-template name="add-class-link">
                    <xsl:with-param name="class" select="type"/>
                  </xsl:call-template>
                </codeph>
              </entry>
               <entry class="- topic/entry " colname="c2" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'4')"/>
                  <xsl:call-template name="add-link">
                    <xsl:with-param name="type" select="'table'"/>
                    <xsl:with-param name="href">
                      <xsl:value-of
                        select="concat('#', dita-ot:name-to-id(ancestor::compounddef/compoundname), '/fields_', $field)"
                      />
                      <xsl:if test="count(../memberdef[name=$field])&gt;1">
                        <xsl:value-of select="count(following-sibling::memberdef[name=$field])"/>
                      </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$field"/>
                  </xsl:call-template>
                </codeph>
                <xsl:if test="normalize-space(briefdescription)!=''">
                  <xsl:value-of select="concat (' - ', briefdescription)"/>
                </xsl:if>
              </entry>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>

  <!--
      Field Details
  -->
  <xsl:template match="memberdef" mode="field">
    <xsl:variable name="field" select="name"/>
    <xsl:variable name="field_details">
      <codeph class="+ topic/ph pr-d/codeph ">
        <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'5')"/>
        <xsl:value-of select="concat(@scope, ' ')"/>
        <xsl:if test="@static='true'">
          <xsl:text>static </xsl:text>
        </xsl:if>
        <xsl:if test="@final='true'">
          <xsl:text>final </xsl:text>
        </xsl:if>
        <xsl:call-template name="add-class-link">
          <xsl:with-param name="class" select="type"/>
        </xsl:call-template>
        <xsl:value-of select="concat(' ',$field)"/>
      </codeph>
      <xsl:call-template name="parse-brief-description"/>
      <xsl:call-template name="parse-detailed-description"/>
    </xsl:variable>

    <table class="- topic/table " outputclass="field_details">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('fields_',$field)"/>
        <xsl:if test="count(../memberdef[name=$field])&gt;1">
          <xsl:value-of select="count(following-sibling::memberdef[name=$field])"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="mini-table">
        <xsl:with-param name="header">
          <xsl:value-of select="$field"/>
        </xsl:with-param>
        <xsl:with-param name="body" select="$field_details"/>
      </xsl:call-template>
    </table>
    <p class="- topic/p "/>
  </xsl:template>


  <!--
    Typedefs Summary
  -->
  <xsl:template name="add-typedefs-summary">
    <table class="- topic/table " outputclass="typedefs_summary">
      <tgroup class="- topic/tgroup " cols="2">
        <colspec class="- topic/colspec " colname="c1" colnum="1" colwidth="25%"/>
        <colspec class="- topic/colspec " colname="c2" colnum="2" colwidth="75%"/>
        <thead class="- topic/thead ">
          <row class="- topic/row ">
            <entry class="- topic/entry " colname="c1" align="left">
              <xsl:text>Name</xsl:text>
            </entry>
            <entry class="- topic/entry " colname="c2" align="left">
              <xsl:text>Description</xsl:text>
            </entry>
          </row>
        </thead>
        <tbody class="- topic/tbody ">
          <xsl:for-each select="sectiondef/memberdef[@kind='typedef' and @prot='public']">
            <xsl:sort select="name"/>
            <xsl:variable name="field" select="name"/>
            <row class="- topic/row ">
              <entry class="- topic/entry " colname="c1" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'3')"/>
                  <xsl:call-template name="add-link">
                    <xsl:with-param name="type" select="'table'"/>
                    <xsl:with-param name="href">
                      <xsl:value-of
                        select="concat('#', dita-ot:name-to-id(ancestor::compounddef/compoundname), '/typedefs_', $field)"
                      />
                      <xsl:if test="count(../memberdef[name=$field])&gt;1">
                        <xsl:value-of select="count(following-sibling::memberdef[name=$field])"/>
                      </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$field"/>
                  </xsl:call-template>
                </codeph>
              </entry>
              <entry class="- topic/entry " colname="c2" align="left">
                <xsl:if test="normalize-space(briefdescription)!=''">
                  <xsl:value-of select="concat (' - ', briefdescription)"/>
                </xsl:if>
              </entry>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  

  <!--
      typedef Details
  -->
  <xsl:template match="memberdef" mode="typedef">
    <xsl:variable name="field" select="name"/>
    <xsl:variable name="field_details">
      <codeph class="+ topic/ph pr-d/codeph ">
        <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'5')"/>
        <xsl:value-of select="concat(' ',./definition)"/>
      </codeph>
      <xsl:call-template name="parse-brief-description"/>
      <xsl:call-template name="parse-detailed-description"/>
    </xsl:variable>

    <table class="- topic/table " outputclass="typedef_details">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('typedefs_',$field)"/>
        <xsl:if test="count(../memberdef[name=$field])&gt;1">
          <xsl:value-of select="count(following-sibling::memberdef[name=$field])"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="mini-table">
        <xsl:with-param name="header">
          <xsl:value-of select="$field"/>
        </xsl:with-param>
        <xsl:with-param name="body" select="$field_details"/>
      </xsl:call-template>
    </table>
    <p class="- topic/p "/>
  </xsl:template>




</xsl:stylesheet>
