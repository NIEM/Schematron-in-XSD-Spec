<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2"><sch:title>Rules for NIEM Schematron in XSD</sch:title>
<sch:ns prefix="ct" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
<sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
<sch:ns prefix="six" uri="http://release.niem.gov/niem/sch-in-xsd/1.0/"/>
<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
        
<sch:pattern id="rule_5-2"><sch:title>Document has xs:schema document element</sch:title>
  <sch:rule context="/">
    <sch:assert test="/xs:schema">Rule 5-2: The document MUST have document element xs:schema.</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-3"><sch:title>XML Schema elements do not appear as content of annotations</sch:title>
  <sch:rule context="xs:*">
    <sch:assert test="empty(ancestor::xs:appinfo | ancestor::xs:documentation)">Rule 5-3: An element in the XML Schema namespace MUST NOT appear as content of an XML Schema annotation.</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-5"><sch:title>Document has effective conformance target identifier</sch:title>
  <sch:rule context="/">
    <sch:assert test="some $conformance-target                        in tokenize(normalize-space( (//@ct:conformanceTargets)[1] ), ' ')                       satisfies $conformance-target = 'http://reference.niem.gov/niem/specification/sch-in-xsd/1.0/#XSDWithSchematron'">Rule 5-5: The document MUST have an effective conformance target identifier "http://reference.niem.gov/niem/specification/sch-in-xsd/1.0/#XSDWithSchematron".</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-6"><sch:title>Attribute six:queryBinding owner element is xs:schema</sch:title>
   <sch:rule context="*[@six:queryBinding]">
     <sch:assert test="self::xs:schema">Rule 5-6: Attribute six:queryBinding MUST have [owner element] xs:schema</sch:assert>
   </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-7"><sch:title>Schema element has query binding</sch:title>
   <sch:rule context="/xs:schema">
     <sch:assert test="@six:queryBinding">Rule 5-7: Document element xs:schema MUST have attribute six:queryBinding</sch:assert>
   </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-8"><sch:title>Attribute six:queryBinding identifies query language</sch:title>
  <sch:rule context="*[@six:queryBinding]">
    <sch:assert test="every $token in tokenize(normalize-space(@six:queryBinding),' ')                       satisfies $token = ('xslt1', 'xslt2', 'xslt2-sa')">Rule 5-8: Attribute six:queryBinding must indicate query language binding.</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_5-10"><sch:title>Namespace prefixes declared only on the document element</sch:title>
  <sch:rule context="*[not(self::* is /*)]">
    <sch:let name="element" value="."/>
    <sch:let name="parent" value="$element/parent::*"/>
    <sch:let name="element-prefixes" value="in-scope-prefixes($element)"/>
    <sch:let name="parent-prefixes" value="in-scope-prefixes($parent)"/>
    <sch:assert test="every $prefix in $element-prefixes                        satisfies ($prefix = $parent-prefixes                                  and namespace-uri-for-prefix($prefix, $element)                                       = namespace-uri-for-prefix($prefix, $parent))                       and (every $prefix                            in $parent-prefixes                            satisfies $prefix = $element-prefixes)">Rule 5-10: The document MUST NOT have a namespace prefix definition on any element that is not the document element.</sch:assert>
  </sch:rule>
</sch:pattern>            
        
<sch:pattern id="rule_5-14"><sch:title>XSLT elements allowed only as top-level annotations</sch:title>
  <sch:rule context="xs:*/xsl:*">
    <sch:assert test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]">Rule 5-14: An XSLT element MUST be application information on the schema document.</sch:assert>
  </sch:rule>
</sch:pattern>              
          
<sch:pattern id="rule_5-15"><sch:title>Most Schematron elements allowed only as top-level annotations</sch:title>
  <sch:rule context="xs:*/sch:*[not(self::sch:assert)                                 and not(self::sch:report)                                 and not(self::sch:let)]">
    <sch:assert test="parent::xs:appinfo[parent::xs:annotation[.. is /xs:schema]]">Rule 5-15: A Schematron element other than sch:assert, sch:report, and sch:let MUST be application information on the schema document.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_5-16"><sch:title>Schematron assert, report, let allowed on particular components</sch:title>
  <sch:rule context="xs:*/sch:assert                      | xs:*/sch:report                       | xs:*/sch:let">
    <sch:assert test="parent::xs:appinfo[parent::xs:annotation[parent::xs:*[                         (: top-level components :)                         ( ( self::xs:element or self::xs:attribute                              or self::xs:complexType or self::xs:simpleType )                           and ( .. is /xs:schema ) )                         (: element and attribute uses :)                         or ( ( self::xs:element[@ref] or self::xs:attribute[@ref] )                              and ancestor::xs:complexType[.. is /xs:schema] ) ]]]">Rule 5-16: A Schematron assert, report, or let element MUST be application information on one of: a global attribute declaration, a global element declaration, a global complex type definition, a global simple type definition, a global element particle within a global complex type definition, or a global attribute use within a global complex type definition.</sch:assert>
  </sch:rule>
</sch:pattern>              
          </sch:schema>