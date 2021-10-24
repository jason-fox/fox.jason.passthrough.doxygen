<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA-OT Doxygen Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  version="2.0"
>

    <xsl:template match="*[contains(@class,' topic/topic ') and contains(@props,'doxygen')]">
		<fo:block break-before="page"/>
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
