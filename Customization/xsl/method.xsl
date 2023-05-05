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
    Method Summary
  -->
  <xsl:template name="add-method-summary">
    <table class="- topic/table " outputclass="method_summary">
      <tgroup class="- topic/tgroup " cols="2">
        <colspec class="- topic/colspec " colname="c1" colnum="1" colwidth="25%"/>
        <colspec class="- topic/colspec " colname="c2" colnum="2" colwidth="75%"/>
        <thead class="- topic/thead ">
          <row class="- topic/row ">
            <entry class="- topic/entry " colname="c1" align="left">
               <xsl:text>Modifier and Type</xsl:text>
            </entry>
            <entry class="- topic/entry " colname="c2" align="left">
               <xsl:text>Method and Description</xsl:text>
            </entry>
          </row>
        </thead>
        <tbody class="- topic/tbody ">
          <xsl:for-each
            select="sectiondef/memberdef[ (@kind='function' or @kind='slot') and not(type='') and @prot='public']"
          >
            <xsl:sort select="name"/>
            <xsl:variable name="method" select="name"/>
            <row class="- topic/row ">
              <entry class="- topic/entry " colname="c1" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'12')"/>
                  <xsl:call-template name="add-modifiers"/>
                  <xsl:call-template name="add-type-link">
                    <xsl:with-param name="refid" select="type/ref/@refid"/>
                    <xsl:with-param name="reftext" select="type"/>
                  </xsl:call-template>
                </codeph>
              </entry>
               <entry class="- topic/entry " colname="c2" align="left">
                <codeph class="+ topic/ph pr-d/codeph ">
                  <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'13')"/>
                  <xsl:call-template name="add-link">
                    <xsl:with-param name="type" select="'table'"/>
                    <xsl:with-param name="href">
                      <xsl:value-of
                        select="concat('#', dita-ot:name-to-id(ancestor::compounddef/compoundname), '/methods_', $method)"
                      />
                      <xsl:if test="count(../memberdef[name=$method])&gt;1">
                        <xsl:value-of select="count(following-sibling::memberdef[name=$method])"/>
                      </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="text" select="$method"/>
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

    <xsl:variable name="current_id" select="@id"/>

    <xsl:for-each select="inheritancegraph/node">
      <xsl:if test="childnode[@relation='public-inheritance']">
        <xsl:variable name="extends">
          <xsl:value-of select="link/@refid"/>
        </xsl:variable>
        <xsl:if test="link/@refid and $extends!=$current_id">
          <xsl:call-template name="inheritance-method-summary">
              <xsl:with-param name="extends" select="//compounddef[@kind='class' and @id=$extends]"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--
    List methods from inherited classes
  -->
  <xsl:template name="inheritance-method-summary">
    <xsl:param name="extends"/>

    <xsl:variable name="inherited_id">
      <xsl:value-of select="$extends/compoundname"/>
    </xsl:variable>
    
   
    <xsl:variable name="inherited_methods">
      <xsl:text>Methods inherited from </xsl:text>
      <xsl:value-of select="concat ('Class ',replace($inherited_id, '::\w*$','::'))"/>

      <xsl:call-template name="add-link">
        <xsl:with-param name="type" select="'topic'"/>
        <xsl:with-param name="href" select="concat('#', dita-ot:name-to-id($inherited_id))"/>
        <xsl:with-param name="text" select="replace($inherited_id, '^.*::','')"/>
      </xsl:call-template>
    </xsl:variable>

    <!--xsl:variable name="inherited_methods_details" select="''" /-->

    <xsl:variable name="inherited_methods_details">
      <xsl:for-each
        select="$extends/sectiondef/memberdef[(@kind='function' or @kind='slot') and not(type='') and @prot='public']"
      >
        <xsl:sort select="name"/>
        <xsl:variable name="method" select="name"/>
        <codeph class="+ topic/ph pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'14')"/>
          <xsl:call-template name="add-link">
            <xsl:with-param name="type" select="'table'"/>
            <xsl:with-param name="href">
              <xsl:value-of select="concat('#', dita-ot:name-to-id($inherited_id),'/methods_', $method)"/>
              <xsl:if test="count(../memberdef[name=$method])&gt;1">
                <xsl:value-of select="count(following-sibling::memberdef[name=$method])"/>
              </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="text" select="$method"/>
          </xsl:call-template>
        </codeph>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <p class="- topic/p "/>
    <table class="- topic/table " outputclass="method_details">
      <xsl:call-template name="mini-table">
        <xsl:with-param name="header" select="$inherited_methods"/>
        <xsl:with-param name="body" select="$inherited_methods_details"/>
      </xsl:call-template>
    </table>
  </xsl:template>

  <!--
      Method Details
  -->
  <xsl:template match="memberdef" mode="method">
    <xsl:variable name="method" select="name"/>
    <xsl:variable name="method_details">
      <codeblock class="+ topic/pre pr-d/codeblock ">
        <xsl:attribute name="xtrc" select="concat('codeblock:',generate-id(.),'8')"/>
        <xsl:value-of select="concat(@prot, ' ')"/>
        <xsl:call-template name="add-modifiers"/>
        <xsl:call-template name="add-type-link">
          <xsl:with-param name="refid" select="type/ref/@refid"/>
          <xsl:with-param name="reftext" select="type"/>
        </xsl:call-template>
        <xsl:value-of select="concat(' ', $method)"/>
        <xsl:call-template name="add-signature"/>
      </codeblock>
      <xsl:call-template name="parse-brief-description"/>

      <xsl:if test="reimplements">
        <p class="- topic/p ">
          <b class="+ topic/ph hi-d/b ">
            <xsl:text>Overrides:</xsl:text>
          </b>
        </p>
        <xsl:call-template name="add-overrides">
          <xsl:with-param name="method" select="$method"/>
          <xsl:with-param name="refid" select="reimplements/@refid"/>
        </xsl:call-template>
      </xsl:if>


      <xsl:call-template name="parse-detailed-description"/>
      <xsl:call-template name="parameter-description"/>
      <xsl:call-template name="return-description"/>
    </xsl:variable>

    <table class="- topic/table " outputclass="method_details">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('methods_', $method)"/>
        <xsl:if test="count(../memberdef[name=$method])&gt;1">
          <xsl:value-of select="count(following-sibling::memberdef[name=$method])"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="mini-table">
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
    <xsl:value-of
      select="replace(replace(argsstring, '\s*&lt;\s*','&#8203;&lt;&#8203;'), '\s*&gt;\s*', '&#8203;&gt;&#8203;')"
    />
  </xsl:template>

  <!--
    Detailed description of each parameter
  -->
  <xsl:template name="parameter-description">
    <xsl:if test="param">
      <p class="- topic/p ">
        <b class="+ topic/ph hi-d/b ">
          <xsl:text>Parameters:</xsl:text>
        </b>
      </p>
      <ul class="- topic/ul ">
        <xsl:for-each select="param">
          <li class="- topic/li ">
            <codeph class="+ topic/ph pr-d/codeph ">
              <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'15')"/>
              <xsl:value-of select="concat(declname, ' ')"/>
            </codeph>
            <xsl:variable name="declname" select="declname"/>
            <xsl:if test="../detaileddescription//parameteritem[parameternamelist/parametername=$declname]">
              <xsl:value-of
                select="concat(' - ',../detaileddescription//parameteritem[parameternamelist/parametername=$declname]/parameterdescription)"
              />
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
        <b class="+ topic/ph hi-d/b ">
          <xsl:text>Returns:</xsl:text>
        </b>
      </p>
      <p class="- topic/p ">
        <xsl:choose>
          <xsl:when test="detaileddescription//simplesect[@kind='return']">
            <xsl:value-of select="detaileddescription//simplesect[@kind='return']"/>
          </xsl:when>
          <xsl:otherwise>
            <codeph class="+ topic/ph pr-d/codeph ">
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
    <xsl:param name="refid"/>

    <xsl:variable name="extends" select="//member[@refid=$refid]/ancestor::compounddef"/>

    <xsl:for-each select="$extends/compoundname">
      <p class="- topic/p ">
        <codeph class="+ topic/ph pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'17')"/>
          <xsl:call-template name="add-link">
            <xsl:with-param name="type" select="'table'"/>
            <xsl:with-param name="href">
              <xsl:value-of select="concat('#', dita-ot:name-to-id(.), '/methods_', $method)"/>
              <xsl:if test="count($extends/sectiondef/memberdef[name=$method])&gt;1">
                <xsl:value-of
                  select="count($extends/sectiondef/memberdef[@id=$refid]/following-sibling::memberdef[name=$method])"
                />
              </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="text" select="$method"/>
          </xsl:call-template>
        </codeph>
        <xsl:text> in class </xsl:text>
         <codeph class="+ topic/ph pr-d/codeph ">
          <xsl:attribute name="xtrc" select="concat('codeph:',generate-id(.),'18')"/>
          <xsl:call-template name="add-link">
            <xsl:with-param name="type" select="'topic'"/>
            <xsl:with-param name="href" select="concat('#', dita-ot:name-to-id(.))"/>
            <xsl:with-param name="text" select="replace(.,'^.*::','')"/>
          </xsl:call-template>
        </codeph>
      </p>
    </xsl:for-each>
  </xsl:template>

  <!-- Returns the section name prefix which is used to differentiate
    members by prefixing i.e. typedef with "typedefs_" etc. -->
  <xsl:template name="sectionname">
    <xsl:param name="kind" select="@kind"/>
    <xsl:choose>
      <xsl:when test="$kind = 'typedef'"><xsl:text>typedefs</xsl:text></xsl:when>
      <xsl:when test="$kind = 'function'"><xsl:text>methods</xsl:text></xsl:when>
      <xsl:when test="$kind = 'enum'"><xsl:text>enums</xsl:text></xsl:when>
      <xsl:when test="$kind = 'slot'"><xsl:text>methods</xsl:text></xsl:when>
      <xsl:when test="$kind = 'property'"><xsl:text>properties</xsl:text></xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
        <xsl:message terminate="yes"><xsl:text>undefined kind for </xsl:text><xsl:value-of select="$kind"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-type-link">
    <xsl:param name="refid"/>
    <xsl:param name="reftext"/>
    
    <xsl:variable name="refed-type-xref-kind">
      <xsl:choose>
          <!-- refid points to a componddef -->
          <xsl:when test="//compounddef[@id = $refid]">
              <xsl:text>topic</xsl:text>
          </xsl:when>
          <!-- refid points to a member, which is rendered into a table -->
          <xsl:when test="//memberdef[@id = $refid]">
              <xsl:text>table</xsl:text>
          </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="refed-type-fullname">
        <xsl:choose>
          <!-- Empty text, so no ref -->
          <xsl:when test="normalize-space($reftext) = ''">
          </xsl:when>

          <!-- Empty ref, so deliver text -->
          <xsl:when test="not ($refid)">
              <xsl:value-of select="$reftext"/>              
          </xsl:when>
        
          <!-- refid points to a componddef -->
          <xsl:when test="//compounddef[@id = $refid]/compoundname">
              <xsl:value-of select ="//compounddef[@id = $refid]/compoundname"/>
          </xsl:when>

          <!-- refid points to a memberdef -->
          <xsl:when test="//memberdef[@id = $refid]/ancestor::compounddef/compoundname">
            <xsl:variable name="memberdef" select="//memberdef[@id = $refid]"/>
            <xsl:variable name="section">
              <xsl:call-template name="sectionname">
                <xsl:with-param name="kind" select="$memberdef/@kind"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select ="$memberdef/ancestor::compounddef/compoundname"/>
            <xsl:value-of select="concat('/', $section,'_')"/>
            <xsl:value-of select="$memberdef/name"/>
          </xsl:when>

          <xsl:otherwise>
              <xsl:message terminate="yes"><xsl:text>add-type-link: Unable to find compound name for: </xsl:text><xsl:value-of select="type"/></xsl:message>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="refid-resolved" select="dita-ot:name-to-id($refed-type-fullname)"/>
    <xsl:variable name="reftext-clean" select="replace($reftext,'^.*\.','')"/>
    <xsl:choose>
      <xsl:when test="$refid">
        <xsl:call-template name="add-link">
          <xsl:with-param name="type" select="$refed-type-xref-kind"/>
          <xsl:with-param name="href" select="concat('#', $refid-resolved)"/>
          <xsl:with-param name="text" select="$reftext-clean"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$reftext"/>
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
