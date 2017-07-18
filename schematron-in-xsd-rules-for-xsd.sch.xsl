<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:six="http://release.niem.gov/niem/schematron-in-xsd/4.0/"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/conformanceTargets/3.0/" prefix="ct"/>
         <svrl:ns-prefix-in-attribute-values uri="http://purl.oclc.org/dsdl/schematron" prefix="sch"/>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/schematron-in-xsd/4.0/" prefix="six"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-2</xsl:attribute>
            <xsl:attribute name="name">Document has xs:schema document element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M4"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-3</xsl:attribute>
            <xsl:attribute name="name">XML Schema elements do not appear as content of annotations</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-5</xsl:attribute>
            <xsl:attribute name="name">Document has effective conformance target identifier</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-6</xsl:attribute>
            <xsl:attribute name="name">Attribute six:queryBinding owner element
      is xs:schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-7</xsl:attribute>
            <xsl:attribute name="name">Schema element has query binding</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-8</xsl:attribute>
            <xsl:attribute name="name">Attribute six:queryBinding identifies query language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-10</xsl:attribute>
            <xsl:attribute name="name">Namespace prefixes declared only on the document element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-11</xsl:attribute>
            <xsl:attribute name="name">No use of sch:ns</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-14</xsl:attribute>
            <xsl:attribute name="name">XSLT elements allowed only as top-level annotations</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-15</xsl:attribute>
            <xsl:attribute name="name">Most Schematron elements allowed only as top-level annotations</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_3-16</xsl:attribute>
            <xsl:attribute name="name">Schematron assert, report, let allowed on particular components</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN rule_3-2Document has xs:schema document element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Document has xs:schema document element</svrl:text>

	  <!--RULE -->
   <xsl:template match="/" priority="1000" mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="/xs:schema"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="/xs:schema">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-2: The document MUST have document element xs:schema.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>

   <!--PATTERN rule_3-3XML Schema elements do not appear as content of annotations-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">XML Schema elements do not appear as content of annotations</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*" priority="1000" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(ancestor::xs:appinfo | ancestor::xs:documentation)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(ancestor::xs:appinfo | ancestor::xs:documentation)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-3: An element in the XML Schema namespace MUST NOT appear as content of an XML Schema annotation.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>

   <!--PATTERN rule_3-5Document has effective conformance target identifier-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Document has effective conformance target identifier</svrl:text>

	  <!--RULE -->
   <xsl:template match="/" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $conformance-target                        in tokenize(normalize-space( (//@ct:conformanceTargets)[1] ), ' ')                       satisfies $conformance-target = 'http://reference.niem.gov/niem/specification/schematron-in-xsd/4.0/#XSDWithSchematron'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $conformance-target in tokenize(normalize-space( (//@ct:conformanceTargets)[1] ), ' ') satisfies $conformance-target = 'http://reference.niem.gov/niem/specification/schematron-in-xsd/4.0/#XSDWithSchematron'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-5: The document MUST have an effective conformance target identifier "http://reference.niem.gov/niem/specification/schematron-in-xsd/4.0/#XSDWithSchematron".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN rule_3-6Attribute six:queryBinding owner element
      is xs:schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute six:queryBinding owner element
      is xs:schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[@six:queryBinding]" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@six:queryBinding]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::xs:schema"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="self::xs:schema">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-6: Attribute six:queryBinding MUST have [owner element] xs:schema</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN rule_3-7Schema element has query binding-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema element has query binding</svrl:text>

	  <!--RULE -->
   <xsl:template match="/xs:schema" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/xs:schema"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@six:queryBinding"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@six:queryBinding">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-7: Document element xs:schema MUST have attribute six:queryBinding</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN rule_3-8Attribute six:queryBinding identifies query language-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute six:queryBinding identifies query language</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[@six:queryBinding]" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@six:queryBinding]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $token in tokenize(normalize-space(@six:queryBinding),' ')                       satisfies $token = ('xslt1', 'xslt2', 'xslt2-sa')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $token in tokenize(normalize-space(@six:queryBinding),' ') satisfies $token = ('xslt1', 'xslt2', 'xslt2-sa')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-8: Attribute six:queryBinding must indicate query language binding.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN rule_3-10Namespace prefixes declared only on the document element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace prefixes declared only on the document element</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[not(self::* is /*)]" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[not(self::* is /*)]"/>
      <xsl:variable name="element" select="."/>
      <xsl:variable name="parent" select="$element/parent::*"/>
      <xsl:variable name="element-prefixes" select="in-scope-prefixes($element)"/>
      <xsl:variable name="parent-prefixes" select="in-scope-prefixes($parent)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $prefix in $element-prefixes                        satisfies ($prefix = $parent-prefixes                                  and namespace-uri-for-prefix($prefix, $element)                                       = namespace-uri-for-prefix($prefix, $parent))                       and (every $prefix                            in $parent-prefixes                            satisfies $prefix = $element-prefixes)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $prefix in $element-prefixes satisfies ($prefix = $parent-prefixes and namespace-uri-for-prefix($prefix, $element) = namespace-uri-for-prefix($prefix, $parent)) and (every $prefix in $parent-prefixes satisfies $prefix = $element-prefixes)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-10: Within the document MUST NOT have a namespace prefix definition on any element that is not the document element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN rule_3-11No use of sch:ns-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of sch:ns</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:appinfo/sch:ns" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:appinfo/sch:ns"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-11: The schema document MUST NOT contain application information element sch:ns.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN rule_3-14XSLT elements allowed only as top-level annotations-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">XSLT elements allowed only as top-level annotations</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*/xsl:*" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*/xsl:*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-14: An XSLT element MUST be application information on the schema document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN rule_3-15Most Schematron elements allowed only as top-level annotations-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Most Schematron elements allowed only as top-level annotations</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*/sch:*[not(self::sch:assert)                                 and not(self::sch:report)                                 and not(self::sch:let)]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*/sch:*[not(self::sch:assert)                                 and not(self::sch:report)                                 and not(self::sch:let)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-15: A Schematron element other than sch:assert, sch:report, and sch:let MUST be application information on the schema document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN rule_3-16Schematron assert, report, let allowed on particular components-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron assert, report, let allowed on particular components</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*/sch:assert                      | xs:*/sch:report                       | xs:*/sch:let"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*/sch:assert                      | xs:*/sch:report                       | xs:*/sch:let"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="parent::xs:appinfo[parent::xs:annotation[parent::xs:*[                         (: top-level components :)                         ( ( self::xs:element or self::xs:attribute                              or self::xs:complexType or self::xs:simpleType )                           and ( .. is /xs:schema ) )                         (: element and attribute uses :)                         or ( ( self::xs:element[@ref] or self::xs:attribute[@ref] )                              and ancestor::xs:complexType[.. is /xs:schema] ) ]]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="parent::xs:appinfo[parent::xs:annotation[parent::xs:*[ (: top-level components :) ( ( self::xs:element or self::xs:attribute or self::xs:complexType or self::xs:simpleType ) and ( .. is /xs:schema ) ) (: element and attribute uses :) or ( ( self::xs:element[@ref] or self::xs:attribute[@ref] ) and ancestor::xs:complexType[.. is /xs:schema] ) ]]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 3-16: A Schematron assert, report, or let element MUST be application information on one of: a global attribute declaration, a global element declaration, a global complex type definition, a global simple type definition, a global element particle within a global complex type definition, or a global attribute use within a global complex type definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
</xsl:stylesheet>
