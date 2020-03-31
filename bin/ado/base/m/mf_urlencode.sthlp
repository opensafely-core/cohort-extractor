{smcl}
{* *! version 1.0.4  15may2018}{...}
{vieweralsosee "[M-5] urlencode()" "mansection M-5 urlencode()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "mf_urlencode##syntax"}{...}
{viewerjumpto "Description" "mf_urlencode##description"}{...}
{viewerjumpto "Conformability" "mf_urlencode##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_urlencode##diagnostics"}{...}
{viewerjumpto "Source code" "mf_urlencode##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] urlencode()} {hline 2}}Convert URL into percent-encoded ASCII format
{p_end}
{p2col:}({mansection M-5 urlencode():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar} {cmd:urlencode(}{it:string scalar s}[{cmd:,} {it:real scalar useplus}]{cmd:)}

{p 8 12 2}
{it:string scalar} {cmd:urldecode(}{it:string scalar s}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:urlencode(}{it:s}[{cmd:,} {it:useplus}]{cmd:)} converts a string into 
percent-encoded ASCII format for web transmission.  It replaces reserved ASCII 
characters with a {cmd:%} followed by two hexadecimal digits.  The function 
replaces a space with {cmd:%20} if {it:useplus} is not specified or is
{cmd:0}; it replaces a space with a {cmd:+} if {it:useplus} is 1.

{p 4 4 2}
{cmd:urldecode(}{it:s}{cmd:)} decodes the string obtained from {cmd:urlencode()}
and returns the original string.  


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:urlencode(}{it:s}[{cmd:,} {it:useplus}]{cmd:)},
{cmd:urldecode(}{it:s}{cmd:)}:
{p_end}
	    {it:s}:  1 {it:x} 1
      {it:useplus}:  1 {it:x} 1 
       {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
