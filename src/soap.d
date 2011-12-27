module soap;

private import 	
	std.xml,
	std.conv;


struct SoapElement
{
	string namespace;
	Element element;
	
	string toString()
	{
		return element.toString;
	}
}

struct SoapEnvelope
{
	SoapElement[] headerElements;
	SoapElement[] bodyElements;
	
	string toString()
	{
		Element e = new Element("soap:Envelope");
		e.tag.attr["xmlns:soap"] = "http://www.w3.org/2001/12/soap-envelope";
		e.tag.attr["soap:encodingStyle"] = "http://www.w3.org/2001/12/soap-encoding";
		
		Element headerElement = new Element("soap:Header");
		Element bodyElement = new Element("soap:Body");
			
		int cnt = 0;
		foreach(header; headerElements)
		{
			auto ns = "ns" ~ to!(string)(cnt++);
			e.tag.attr["xmlns:" ~ ns] = header.namespace;
			header.element.tag.name = ns ~ ":" ~ header.element.tag.name;
			headerElement ~= header.element;
		}
		
		foreach(bode; bodyElements)
		{
			auto ns = "ns" ~ to!(string)(cnt++);
			e.tag.attr["xmlns:" ~ ns] = bode.namespace;
			bode.element.tag.name = ns ~ ":" ~ bode.element.tag.name;
			bodyElement ~= bode.element;
		}
		
		e ~= headerElement;
		e ~= bodyElement;
		
		return e.toString();
	}
}
