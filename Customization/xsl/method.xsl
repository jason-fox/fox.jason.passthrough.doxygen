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
    Method Summary
  -->
  <xsl:template name="add-method-summary">
    <table class=" topic/table " outputclass="method_summary">
      <tgroup class=" topic/tgroup " cols="2">
        <colspec class=" topic/colspec " colname="c1" colnum="1" colwidth="25%"/>
        <colspec class=" topic/colspec " colname="c2" colnum="2" colwidth="75%"/>
        <thead class=" topic/thead ">
          <row class=" topic/row ">
            <entry class=" topic/entry " colname="c1" dita-ot:x="1" align="left">
               <xsl:text>Modifier and Type</xsl:text>
            </entry>
            <entry class=" topic/entry " colname="c2" dita-ot:x="2" align="left">
               <xsl:text>Method and Description</xsl:text>
            </entry>
          </row>
        </thead>
        <tbody class=" topic/tbody ">
          <xsl:for-each select="sectiondef[contains(@kind,'-func')]/memberdef[@kind='function' and not(type='') and @prot='public']">
            <xsl:sort select="name"/>
            <xsl:variable name="method" select="name"/>
            <row class=" topic/row ">
              <entry class=" topic/entry " colname="c1"  dita-ot:x="1" align="left">
                <codeph class=" pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'12')"/>
                  <xsl:call-template name="add-modifiers"/>
                  <xsl:choose>
                    <xsl:when test="type/ref/@refid">
                      <xsl:call-template name="add-class-link">
                        <xsl:with-param name="class" select="type/ref/@refid" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="add-class-link">
                        <xsl:with-param name="class" select="type"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </codeph>
              </entry>
               <entry class=" topic/entry " colname="c2"  dita-ot:x="2" align="left">
                <codeph class=" pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'13')"/>
                  <xsl:call-template name="add-link" >
                    <xsl:with-param name="type" select="'table'" />
                    <xsl:with-param name="href">
                      <xsl:value-of select="concat('#', dita-ot:name-to-id(ancestor::compounddef/compoundname), '/methods_', $method)"/>
                      <xsl:if test="count(../memberdef[name=$method])&gt;1">
                        <xsl:value-of select="count(following-sibling::memberdef[name=$method])"/>
                      </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$method" />
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
  <xsl:template name="add-inherited-method-summary">
    <xsl:variable name="extends">
      <xsl:value-of select="class/@qualified"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="//package/class[@qualified=$extends]">
        <xsl:call-template name="inheritance-method-summary">
          <xsl:with-param name="extends" select = "//package/class[@qualified=$extends]/@qualified" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
    List methods from inherited classes
  -->
  <xsl:template name="inheritance-method-summary">
    <xsl:param name = "extends" />
      
    <xsl:variable name="inherited_methods">
      <xsl:text>Methods inherited from class </xsl:text>
      <xsl:value-of select="replace(@qualified,'\..*$','.')"/>
      <xsl:call-template name="add-link" >
        <xsl:with-param name="type" select="'topic'" />
        <xsl:with-param name="href" select="concat('#', //package/class[@qualified=$extends]/@qualified)" />
        <xsl:with-param name="text" select="//package/class[@qualified=$extends]/@name" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="inherited_methods_details">
      <xsl:for-each select="//package/class[@qualified=$extends]/method">
        <xsl:sort select="@name"/>
        <xsl:variable name="method" select="@name"/>
        <codeph class=" pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'14')"/>
          <xsl:call-template name="add-link" >
            <xsl:with-param name="type" select="'table'" />
            <xsl:with-param name="href">
              <xsl:value-of select="concat('#', $extends,'/methods_', $method)"/>
              <xsl:if test="count(../method[@name=$method])&gt;1">
                <xsl:value-of select="count(following-sibling::method[@name=$method])"/>
              </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="text" select="$method" />
          </xsl:call-template>
        </codeph>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <p class="- topic/p "/>
    <table class=" topic/table " outputclass="method_details">
      <xsl:call-template name="mini-table" >
        <xsl:with-param name="header" select="$inherited_methods"/>
        <xsl:with-param name="body" select="$inherited_methods_details"/>
      </xsl:call-template>
    </table>

    <xsl:variable name="reextends">
      <xsl:value-of select="//package/class[@qualified=$extends]/class/@qualified"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="//package/class[@qualified=$reextends]">
        <xsl:call-template name="inheritance-method-summary" >
          <xsl:with-param name="extends" select = "//package/class[@qualified=$reextends]/@qualified" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
      Method Details
  -->
  <xsl:template match="memberdef" mode="method">
    <xsl:variable name="method" select="name"/>
    <xsl:variable name="method_details">
      <codeblock class=" pr-d/codeblock ">
        <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'8')"/>
        <xsl:value-of select="concat(@prot, ' ')"/>
        <xsl:call-template name="add-modifiers"/>
        <xsl:choose>
          <xsl:when test="type/ref/@refid">
            <xsl:call-template name="add-class-link">
              <xsl:with-param name="class" select="type/ref/@refid" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="add-class-link">
              <xsl:with-param name="class" select="type"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat(' ', $method)"/>
        <xsl:call-template name="add-signature"/>
      </codeblock>
      <xsl:call-template name="parse-brief-description"/>
      <xsl:call-template name="parameter-description"/>
      <xsl:call-template name="return-description"/>
    </xsl:variable>

    <table class=" topic/table " outputclass="method_details">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('methods_', $method)"/>
        <xsl:if test="count(../memberdef[name=$method])&gt;1">
          <xsl:value-of select="count(following-sibling::memberdef[name=$method])"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="mini-table" >
        <xsl:with-param name="header">
          <xsl:value-of select="$method"/>
        </xsl:with-param>
        <xsl:with-param name="body" select="$method_details"/>
      </xsl:call-template>
    </table>
    <p class="- topic/p "/>
  </xsl:template>

  <!--
    Create a method signature based on the parameter set
  -->
  <xsl:template name="add-signature">
    <xsl:value-of select="replace(replace(argsstring, '\s*&lt;\s*','&#8203;&lt;&#8203;'), '\s*&gt;\s*', '&#8203;&gt;&#8203;')"/>
  </xsl:template>

  <!--
    Detailed description of each parameter
  -->
  <xsl:template name="parameter-description">
    <xsl:if test="param">
      <p class="- topic/p ">
        <b class=" hi-d/b ">
          <xsl:text>Parameters:</xsl:text>
        </b>
      </p>
      <ul class=" topic/ul ">
        <xsl:for-each select="param">
          <li class=" topic/li ">
            <codeph class=" pr-d/codeph ">
              <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'15')"/>
              <xsl:value-of select="concat(declname, ' ')"/>
            </codeph>
            <xsl:variable name="declname" select="declname"/>
            <xsl:if test="../detaileddescription//parameteritem[parameternamelist/parametername=$declname]">
              <xsl:value-of select="concat(' - ',../detaileddescription//parameteritem[parameternamelist/parametername=$declname]/parameterdescription)"/>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <!--
    Detailed description of the return, either signature or text description
  -->
  <xsl:template name="return-description">
    <xsl:if test="not(type='void')">
      <p class="- topic/p ">
        <b class=" hi-d/b ">
          <xsl:text>Returns:</xsl:text>
        </b>
      </p>
      <p class="- topic/p ">
        <xsl:choose >
          <xsl:when test="detaileddescription//simplesect[@kind='return']">
            <xsl:value-of select="detaileddescription//simplesect[@kind='return']"/>
          </xsl:when>
          <xsl:otherwise>
            <codeph class=" pr-d/codeph ">
              <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'16')"/>
              <xsl:value-of select="type"/>
            </codeph>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template name="add-overrides">
      <xsl:param name="method"/>
      <xsl:param name="signature"/>
      <xsl:param name="extends"/>
    
      
      <p class="- topic/p ">
        <codeph class=" pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'17')"/>
          <xsl:call-template name="add-link" >
            <xsl:with-param name="type" select="'table'" />
            <xsl:with-param name="href">
              <xsl:value-of select="concat('#', $extends, '/methods_', $method)" />
              <xsl:if test="count(//package/class[@qualified=$extends]/method[@name=$method])&gt;1">
                <xsl:value-of select="count(//package/class[@qualified=$extends]/method[@name=$method and @signature=$signature]/following-sibling::method[@name=$method])"/>
              </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="text" select="replace(@qualified,'^.*\.','')" />
          </xsl:call-template>
        </codeph>
        <xsl:text> in class </xsl:text>
         <codeph class=" pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'18')"/>
          <xsl:call-template name="add-link" >
            <xsl:with-param name="type" select="'topic'" />
            <xsl:with-param name="href" select="concat('#', $extends)" />
            <xsl:with-param name="text" select="replace($extends,'^.*\.','')" />
          </xsl:call-template>
        </codeph>
      </p>
  </xsl:template>
    <!---
-->
  <xsl:template name="add-class-link">
    <xsl:param name = "class" />
    <xsl:variable name="refid" select="replace(replace($class, '^(interface|class)', ''), '_1_1', '.')"/>

    <xsl:choose>
      <xsl:when test="//compounddef[@kind='class' and @id=$class]">
        <xsl:call-template name="add-link" >
          <xsl:with-param name="type" select="'topic'" />
          <xsl:with-param name="href" select="concat('#', $refid)"/>
          <xsl:with-param name="text" select="replace($refid,'^.*\.','')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="//compounddef[@kind='interface' and @id=$class]">
        <xsl:call-template name="add-link" >
          <xsl:with-param name="type" select="'topic'" />
          <xsl:with-param name="href" select="concat('#', $refid)"/>
          <xsl:with-param name="text" select="replace($refid,'^.*\.','')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="//compounddef[@kind='interface' and @id=$class]">
        <xsl:call-template name="add-link" >
          <xsl:with-param name="type" select="'topic'" />
          <xsl:with-param name="href" select="concat('#', $refid)"/>
          <xsl:with-param name="text" select="replace($refid,'^.*\.','')" />
        </xsl:call-template>
      </xsl:when>
       <xsl:when test="starts-with($class,'java.lang.')">
         <xsl:value-of select="dita-ot:addZeroWidthSpaces($class)"/>
      </xsl:when>
      <xsl:when test="$class">
        <xsl:variable name="signature" select="replace($class,'^.*\.','')"/>
        <xsl:value-of select="replace(replace($signature, '\s*&lt;\s*','&#8203;&lt;&#8203;'), '\s*&gt;\s*', '&#8203;&gt;&#8203;')"/>

      </xsl:when>
      <xsl:otherwise>
        <xsl:text>????</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-modifiers">
    <xsl:if test="@static='yes'">
      <xsl:text>static </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:function name="dita-ot:addZeroWidthSpaces">
    <xsl:param name="text" as="xs:string"/>
    <xsl:value-of select="replace($text,'\.','.&#8203;')"/>
  </xsl:function>

</xsl:stylesheet>