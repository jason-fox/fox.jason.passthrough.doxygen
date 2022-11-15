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
    Iterate over all nodes - this should remove unprocessed elements
    such as <br>, <hr> & etc.
  -->
  <xsl:template match="*" mode="html">
    <xsl:apply-templates mode="html"/>
  </xsl:template>

  <!--
    HTML Header processing <h1> to <h6>
    these are not real headers - just use bold text.
  -->
  <xsl:template match="h1|h2|h3|h4|h5|h6" mode="html">
    <p class="- topic/p ">
      <b class="+ topic/ph hi-d/b ">
        <xsl:apply-templates mode="html"/>
      </b>
    </p>
  </xsl:template>

  <!--
    Paragraph processing
  -->
  <xsl:template match="para" mode="html">
    <xsl:choose>
      <xsl:when test="ancestor::para">
        <xsl:apply-templates mode="html"/>
      </xsl:when>
      <xsl:otherwise>
        <p class="- topic/p ">
          <xsl:apply-templates mode="html"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    Unordered list processing
  -->
  <xsl:template match="ul" mode="html">
    <ul class="- topic/ul ">
      <xsl:apply-templates mode="html"/>
    </ul>
  </xsl:template>

  <!--
    Ordered list processing
  -->
  <xsl:template match="ol" mode="html">
    <ol class="- topic/ol ">
      <xsl:apply-templates mode="html"/>
    </ol>
  </xsl:template>

  <!--
    List Item processing 
    Assume unordered if no parent found
  -->
  <xsl:template match="li" mode="html">
    <xsl:choose>
      <xsl:when test="../name()='ul'">
        <li class="- topic/li ">
          <xsl:apply-templates mode="html"/>
        </li>
      </xsl:when>
      <xsl:when test="../name()='ol'">
        <li class="- topic/li ">
          <xsl:apply-templates mode="html"/>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <ul class="- topic/ul ">
          <li class="- topic/li ">
            <xsl:apply-templates mode="html"/>
          </li>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    Code processing
  -->
  <xsl:template match="code" mode="html">
    <codeph class="+ topic/ph pr-d/codeph ">
      <xsl:apply-templates mode="html"/>
    </codeph>
  </xsl:template>

  <!--
    Codeblock processing
  -->
  <xsl:template match="programlisting" mode="html">
    <codeblock class="+ topic/pre pr-d/codeblock ">
      <xsl:apply-templates mode="html"/>
    </codeblock>
  </xsl:template>

  <!--
    Bold/Strong processing
  -->
  <xsl:template match="b|strong" mode="html">
    <b class="+ topic/ph hi-d/b ">
      <xsl:apply-templates mode="html"/>
    </b>
  </xsl:template>

  <!--
    Italic/Emphasis processing
  -->
  <xsl:template match="em|emphasis|i" mode="html">
    <i class=" hi-d/i ">
      <xsl:apply-templates mode="html"/>
    </i>
  </xsl:template>

  <!--
    Anchor processing
  -->
  <xsl:template match="a" mode="html">
    <xref class="- topic/xref " format="dita" scope="external">
      <xsl:attribute name="href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates mode="html"/>
    </xref>
  </xsl:template>

  <!--
    HTML text processing.

    If no parent found then:
    
      For a single block of text, place the text within a <p> tag

      For text split over multiple paragraphs, place the text within 
      a <lines> tag.
  -->
  <xsl:template match="text()" mode="html">
    <xsl:variable name="text" select="."/>
    <xsl:choose>
      <xsl:when test="../name()='root'">
        <xsl:choose>
          <xsl:when test="contains($text,'&#10;&#10;') ">
            <lines class="- topic/lines ">
              <xsl:value-of select="$text"/>
            </lines>
          </xsl:when>
          <xsl:otherwise>
            <p class="- topic/p ">
              <xsl:value-of select="$text"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
