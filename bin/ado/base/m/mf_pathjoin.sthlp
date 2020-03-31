{smcl}
{* *! version 1.2.1  23jan2019}{...}
{vieweralsosee "[M-5] pathjoin()" "mansection M-5 pathjoin()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_pathjoin##syntax"}{...}
{viewerjumpto "Description" "mf_pathjoin##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_pathjoin##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_pathjoin##remarks"}{...}
{viewerjumpto "Conformability" "mf_pathjoin##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_pathjoin##diagnostics"}{...}
{viewerjumpto "Source code" "mf_pathjoin##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] pathjoin()} {hline 2}}File path manipulation
{p_end}
{p2col:}({mansection M-5 pathjoin():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathjoin(}{it:string scalar path1}{cmd:,}
{it:string scalar path2}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:pathsplit(}{it:string scalar path}{cmd:,}
{it:path1}{cmd:,}
{it:path2}{cmd:)}


{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathbasename(}{it:string scalar path}{cmd:)}


{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathsuffix(}{it:string scalar path}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathrmsuffix(}{it:string scalar path}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:pathisurl(}{it:string scalar path}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:pathisabs(}{it:string scalar path}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:pathasciisuffix(}{it:string scalar path}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:pathstatasuffix(}{it:string scalar path}{cmd:)}


{p 8 12 2}
{it:string rowvector}
{cmd:pathlist(}{it:string scalar dirlist}{cmd:)}

{p 8 12 2}
{it:string rowvector}
{cmd:pathlist()}

{p 8 12 2}
{it:string rowvector}
{cmd:pathsubsysdir(}{it:string rowvector pathlist}{cmd:)}

{p 8 12 2}
{it:string rowvector}
{cmd:pathsearchlist(}{it:string scalar fn}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathresolve(}{it:string scalar basepath}{cmd:,}
{it:path}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:pathgetparent(}{it:string scalar path}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:pathjoin(}{it:path1}{cmd:,} {it:path2}{cmd:)}
forms, logically speaking, {it:path1}{cmd:/}{it:path2}, but does so in the
appropriate style.  For instance, {it:path1} might be a URL and 
{it:path2} a Windows {it:dirname}{cmd:\}{it:filename}, and the two paths 
will, even so, be joined correctly.  All issues of whether {it:path1} 
ends with a directory separator, {it:path2} begins with one, etc., 
are handled automatically.

{p 4 4 2}
{cmd:pathsplit(}{it:path}{cmd:,} {it:path1}{cmd:,} {it:path2}{cmd:)}
performs the inverse operation, removing the last element of the path 
(which is typically a filename) and storing it in {it:path2} and storing the 
rest in {it:path1}.

{p 4 4 2}
{cmd:pathbasename(}{it:path}{cmd:)}
returns the last element of {it:path}.

{p 4 4 2}
{cmd:pathsuffix(}{it:path}{cmd:)}
returns the file suffix, with leading dot, if there is one, and returns ""
otherwise.  For instance, {cmd:pathsuffix("this\that.ado")} returns
"{cmd:.ado}".

{p 4 4 2}
{cmd:pathrmsuffix(}{it:path}{cmd:)}
returns {it:path} with the suffix removed, if there was one.
For instance, 
{cmd:pathrmsuffix("this\that.ado")} returns "{cmd:this\that}".

{p 4 4 2}
{cmd:pathisurl(}{it:path}{cmd:)}
returns 1 if {it:path} is a URL and 0 otherwise.

{p 4 4 2}
{cmd:pathisabs(}{it:path}{cmd:)}
returns 1 if {it:path} is absolute and 0 if relative.  
{cmd:c:\this} is an absolute path.  {cmd:this\that} is a relative path.
URLs are considered to be absolute.

{p 4 4 2}
{cmd:pathasciisuffix(}{it:path}{cmd:)}
and 
{cmd:pathstatasuffix(}{it:path}{cmd:)}
are more for StataCorp use than anything else.
{cmd:pathasciisuffix()} returns 1 if the file is known to be text, 
based on its file suffix.  StataCorp uses this function in Stata's
{cmd:net} command to decide whether end-of-line characters, which 
differ across operating systems, should be modified during downloads.
{cmd:pathstatasuffix()} is the function used by Stata's {cmd:net} and
{cmd:update} commands to decide whether a file belongs in the official 
directories.  {cmd:pathstatasuffix("example.ado")} is true, but 
{cmd:pathstatasuffix("example.do")} is false because 
do-files do not go in system directories.

{p 4 4 2}
{cmd:pathlist(}{it:dirlist}{cmd:)} returns a row vector, 
each element of which contains an element of a semicolon-separated
path list {it:dirlist}.  
For instance, 
{cmd:pathlist("}{it:a}{cmd:;}{it:b}{cmd:;}{it:c}{cmd:")} returns
{cmd:("}{it:a}{cmd:", "}{it:b}{cmd:", "}{it:c}{cmd:")}.

{p 4 4 2}
{cmd:pathlist()} without arguments returns {cmd:pathlist(c("adopath"))},
the broken-out elements of the official Stata ado-path.

{p 4 4 2}
{cmd:pathsubsysdir(}{it:pathlist}{cmd:)} returns {it:pathlist} 
with any elements that are Stata system directories' shorthands, such as 
{cmd:PLUS}, {cmd:PERSONAL}, substituted 
with the actual directory names.  For instance, the right way to 
obtain the official directories over which Stata searches for files 
is {cmd:pathsubsysdir(pathlist())}.

{p 4 4 2}
{cmd:pathsearchlist(}{it:fn}{cmd:)} returns a row vector.  The elements
are full paths/filenames specifying all the locations, in order,
where Stata would look for {it:fn} along the official Stata ado-path.

{p 4 4 2}
{cmd:pathresolve(}{it:basepath}{cmd:,} {it:path}{cmd:)}
returns a resolved path of {it:path} against {it:basepath}.  For example, 
{cmd:pathresolve("c:/test", "../test1")} returns {cmd:"c:/test1"}.

{p 4 4 2}
{cmd:pathgetparent(}{it:path}{cmd:)}
returns the parent path of {it:path}.  For example,
{cmd:pathgetparent("c:/test/test.do")} returns {cmd:"c:/test"}.  Neither
{cmd:c:/test} nor {cmd:c:/test/test.do} need exist.   


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 pathjoin()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Using these functions, you are more likely to produce code that works 
correctly regardless of operating system.

{p 4 4 2}
{cmd:pathremove()} returns an error code if you do not have the necessary
permission to remove the directory or its contents. 

{p 4 4 2}
{cmd:pathresolve(}{it:basepath}{cmd:,} {it:path}{cmd:)} simply returns 
{it:path} if it is an absolute path. 

{p 4 4 2}
{cmd:pathresolve(}{it:basepath}{cmd:,} {it:path}{cmd:)}'s behavior is
undefined if {it:basepath} has no root element, for example, {cmd:../}. 


{marker conformability}{...}
{title:Conformability}

    {cmd:pathjoin(}{it:path1}{cmd:,} {it:path2}{cmd:)}
	    {it:path1}:  1 {it:x} 1
	    {it:path2}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:pathsplit(}{it:path}{cmd:,} {it:path1}{cmd:,} {it:path2}{cmd:)}:
	{it:input:}
	     {it:path}:  1 {it:x} 1
	{it:output:}
	    {it:path1}:  1 {it:x} 1
	    {it:path2}:  1 {it:x} 1

{p 4 4 2}
    {cmd:pathbasename(}{it:path}{cmd:)},
    {cmd:pathsuffix(}{it:path}{cmd:)},
    {cmd:pathrmsuffix(}{it:path}{cmd:)}:
{p_end}
	     {it:path}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:pathisurl(}{it:path}{cmd:)},
{cmd:pathisabs(}{it:path}{cmd:)},
{cmd:pathasciisuffix(}{it:path}{cmd:)},
{cmd:pathstatasuffix(}{it:path}{cmd:)}:
{p_end}
	     {it:path}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:pathlist(}{it:dirlist}{cmd:)}:
	  {it:dirlist}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x k}

    {cmd:pathsubsysdir(}{it:pathlist}{cmd:)}:
	 {it:pathlist}:  1 {it:x k}
	   {it:result}:  1 {it:x k}

    {cmd:pathsearchlist(}{it:fn}{cmd:)}:
	       {it:fn}:  1 {it:x} 1
	   {it:result}:  1 {it:x k}
   
{p 4 4 2}
    {cmd:pathresolve(}{it:basepath}{cmd:,} {it:path}{cmd:)}:
{p_end}
	  {it:basepath}:  1 {it:x} 1
	      {it:path}:  1 {it:x} 1
	    {it:result}:  1 {it:x} 1

{p 4 4 2}
	{cmd:pathgetparent(}{it:path}{cmd:)}:
{p_end}
	      {it:path}:  1 {it:x} 1
	    {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All routines abort with error if the path is too long for the operating 
system.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view pathsplit.mata, adopath asis:pathsplit.mata},
{view pathlist.mata, adopath asis:pathlist.mata},
{view pathsubsysdir.mata, adopath asis:pathsubsysdir.mata},
{view pathsearchlist.mata, adopath asis:pathsearchlist.mata};
other functions are built in.
{p_end}
