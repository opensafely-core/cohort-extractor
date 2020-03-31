{smcl}
{* *! version 1.0.1  23feb2019}{...}
{vieweralsosee "[M-5] issamefile()" "mansection M-5 issamefile()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_issamefile##syntax"}{...}
{viewerjumpto "Description" "mf_issamefile##description"}{...}
{viewerjumpto "Remarks" "mf_issamefile##remarks"}{...}
{viewerjumpto "Conformability" "mf_issamefile##conformability"}{...}
{viewerjumpto "Source code" "mf_issamefile##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] issamefile()} {hline 2}}Whether two file paths are pointing to the same file
{p_end}
{p2col:}({mansection M-5 issamefile():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:issamefile(}{it:string scalar} {it:{help filename:path1}}{cmd:,}
                 {it:string scalar} {it:{help filename:path2}}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:issamefile(}{it:string scalar} {it:{help filename:path1}}{cmd:,}
{it:string scalar} {it:{help filename:path2}}{cmd:)}
returns 1 if {it:path1} and {it:path2} point to the same file (the file must
exist in the file system) and 0 otherwise.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:issamefile("C:/test/test.do", "./test.do")} returns 1 if the current
working directory is {cmd:C:/test/} and file {cmd:C:/test/test.do} exists. 

{p 4 4 2}
{cmd:issamefile()} returns 0 if {it:{help filename:path1}} and
{it:{help filename:path2}} do not point to the same file or if
{it:path1} or {it:path2} points to a file that does not exist.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
    {cmd:issamefile(}{it:{help filename:path1}}{cmd:,} {it:{help filename:path2}}{cmd:)}:
{p_end}
	  {it:path1}:  1 {it:x} 1
	  {it:path2}:  1 {it:x} 1
	 {it:result}:  1 {it:x} 1


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
