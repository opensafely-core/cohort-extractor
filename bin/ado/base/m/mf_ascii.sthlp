{smcl}
{* *! version 1.1.10  24jan2019}{...}
{vieweralsosee "[M-5] ascii()" "mansection M-5 ascii()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] isascii()" "help mf_isascii"}{...}
{vieweralsosee "[M-5] uchar()" "help mf_uchar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_ascii##syntax"}{...}
{viewerjumpto "Description" "mf_ascii##description"}{...}
{viewerjumpto "Conformability" "mf_ascii##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ascii##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ascii##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] ascii()} {hline 2}}Manipulate ASCII and byte codes
{p_end}
{p2col:}({mansection M-5 ascii():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector} {cmd:ascii(}{it:string scalar s}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:  }{cmd:char(}{it:real rowvector c}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ascii(}{it:s}{cmd:)}
returns a row vector containing the ASCII codes (0-127) and byte codes
(128-255) corresponding to {it:s}.  For instance, {cmd:ascii("abc")} returns
(97, 98, 99); {cmd:ascii("café")} returns (99, 97, 102, 195, 169).  Note that
the Unicode character "é" is beyond ASCII range.  Its UTF-8 encoding requires
2 bytes and their byte values are 195 and 169.

{p 4 4 2}
{cmd:char(}{it:c}{cmd:)}
returns a UTF-8 encoded string consisting of the specified ASCII and byte
codes.  For instance, {cmd:char((97, 98, 99))} returns "abc", and 
{cmd:char((99, 97, 102, 195, 169))} returns "café".


{marker conformability}{...}
{title:Conformability}

    {cmd:ascii(}{it:s}{cmd:)}:
	    {it:s}:  1 {it:x} 1
       {it:result}:  1 {it:x} {cmd:strlen(}{it:s}{cmd:)}

    {cmd:char(}{it:c}{cmd:)}
	    {it:c}:  1 {it:x} {it:n}, {it:n}>=0
       {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ascii(}{it:s}{cmd:)} returns {cmd:J(1,0,.)}  if
{cmd:strlen(}{it:s}{cmd:)==0}.

{p 4 4 2}
In {cmd:char(}{it:c}{cmd:)}, if any element of {it:c} is outside the range 0
to 255, the returned string is terminated at that point.  For instance,
{cmd:char((97,98,99,1000,97,98,99))=="abc"}.

{p 4 4 2}
{cmd:char(J(1,0,.))} returns "".


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
