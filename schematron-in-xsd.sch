<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2"><sch:title>Embedding Schematron in XML Schema Documents</sch:title>
<sch:pattern id="rule_6-2"><sch:title>XML Schema elements do not appear as application information</sch:title>
  <sch:rule context="xs:*">
    <sch:assert test="empty(ancestor::xs:appinfo)">Rule 6-2: An XML Schema element must not appear as a descendant of an element xs:appinfo</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_6-4"><sch:title>Document has effective conformance target identifier</sch:title>
  <sch:rule context="/xs:schema">
    <sch:assert test="some $conformance-target                        in tokenize(normalize-space( (.//@ct:conformanceTargets)[1] ))                       satisfies $conformance-target = 'http://reference.niem.gov/niem/specification/sch-in-xsd/1.0/#XSDWithEmbeddedSchematron'">Rule 6-4: The document MUST have an effective conformance target identifier "http://reference.niem.gov/niem/specification/sch-in-xsd/1.0/#XSDWithEmbeddedSchematron".</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_6-5"><sch:title>Attribute six:queryBinding owner element is xs:schema</sch:title>
   <sch:rule context="*/@six:queryBinding">
     <sch:assert test="node-name() = xs:QName('xs:schema')">Rule 6-5: Attribute six:queryBinding MUST have [owner element] xs:schema</sch:assert>
   </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_6-6"><sch:title>Schema element has query binding</sch:title>
   <sch:rule context="/xs:schema">
     <sch:assert test="@six:queryBinding">Rule 6-6: Document element xs:schema MUST have attribute six:queryBinding</sch:assert>
   </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_6-7"><sch:title>Attribute six:queryBinding identifies query language</sch:title>
  <sch:rule context="*/@six:queryBinding">
    <sch:assert test="@six:queryBinding = ('xslt1', 'xslt2-basic', 'xslt2-sa')">Rule 6-7: Attribute six:queryBinding must indicate query language binding.</sch:assert>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_6-9"><sch:title>Namespace prefixes declared only on the document element</sch:title>
  <sch:rule context="*[not(self::* is root(.))]">
    <sch:assert test="for $element in .,                           $parent in parent::* return (                         (every $prefix                           in in-scope-prefixes($element)                          satisfies (                            $prefix = in-scope-prefixes($parent)                            and namespace-uri-for-prefix($prefix, $element)                                 = namespace-uri-for-prefix($prefix, $parent)))                         and every $prefix                             in in-scope-prefixes($parent)                             satisfies $prefix = in-scope-prefixes($element))">Rule 6-9: The document MUST NOT have a namespace prefix definition on any element that is not the document element.</sch:assert>
  </sch:rule>
</sch:pattern>            
        </sch:schema>