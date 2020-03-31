{smcl}
{* *! version 1.2.0  23jan2019}{...}
{vieweralsosee "[M-4] IO" "mansection M-4 IO"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_io##contents"}{...}
{viewerjumpto "Description" "m4_io##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_io##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_io##remarks"}{...}
{viewerjumpto "Reference" "m4_io##reference"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[M-4] IO} {hline 2}}I/O functions
{p_end}
{p2col:}({mansection M-4 IO:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 22}Function{col 43}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 16}{c TRC}
{col 5}{hline 3}{c RT}{it: Console output }{c LT}{hline}
{col 5}   {c BLC}{hline 16}{c BRC}

{col 7}{bf:{help mf_printf:printf()}}{...}
{col 22}{cmd:printf()}{...}
{col 43}display 
{col 22}{cmd:sprintf()}{...}
{col 43}display into string

{col 7}{bf:{help mf_errprintf:errprintf()}}{...}
{col 22}{cmd:errprintf()}{...}
{col 43}display error message

{col 7}{bf:{help mf_display:display()}}{...}
{col 22}{cmd:display()}{...}
{col 43}display text interpreting SMCL

{col 7}{bf:{help mf_displayas:displayas()}}{...}
{col 22}{cmd:displayas()}{...}
{col 43}set whether output is displayed

{col 7}{bf:{help mf_displayflush:displayflush()}}{...}
{col 22}{cmd:displayflush()}{...}
{col 43}flush terminal output buffer

{col 7}{bf:{help mf_liststruct:liststruct()}}{...}
{col 22}{cmd:liststruct()}{...}
{col 43}list structure's contents

{col 7}{bf:{help mf_more:more()}}{...}
{col 22}{cmd:more()}{...}
{col 43}create --more-- condition
{col 22}{cmd:setmore()}{...}
{col 43}query or set more on or off
{col 22}{cmd:setmoreonexit()}{...}
{col 43}set more on or off on exit

{col 5}   {c TLC}{hline 18}{c TRC}
{col 5}{hline 3}{c RT}{it: File directories }{c LT}{hline}
{col 5}   {c BLC}{hline 18}{c BRC}

{col 7}{bf:{help mf_direxists:direxists()}}{...}
{col 22}{cmd:direxists()}{...}
{col 43}whether directory exists

{col 7}{bf:{help mf_dir:dir()}}{...}
{col 22}{cmd:dir()}{...}
{col 43}file list

{col 7}{bf:{help mf_chdir:chdir()}}{...}
{col 22}{cmd:pwd()}{...}
{col 43}obtain current working directory
{col 22}{cmd:chdir()}{...}
{col 43}change current working directory
{col 22}{cmd:mkdir()}{...}
{col 43}make new directory
{col 22}{cmd:rmdir()}{...}
{col 43}remove directory

{col 5}   {c TLC}{hline 17}{c TRC}
{col 5}{hline 3}{c RT}{it: File management }{c LT}{hline}
{col 5}   {c BLC}{hline 17}{c BRC}

{col 7}{bf:{help mf_findfile:findfile()}}{...}
{col 22}{cmd:findfile()}{...}
{col 43}find file

{col 7}{bf:{help mf_fileexists:fileexists()}}{...}
{col 22}{cmd:fileexists()}{...}
{col 43}whether file exists

{col 7}{bf:{help mf_cat:cat()}}{...}
{col 22}{cmd:cat()}{...}
{col 43}read file into string matrix

{col 7}{bf:{help mf_unlink:unlink()}}{...}
{col 22}{cmd:unlink()}{...}
{col 43}erase file

{col 7}{bf:{help mf_adosubdir:adosubdir()}}{...}
{col 22}{cmd:adosubdir()}{...}
{col 43}obtain ado-subdirectory for file

{col 7}{bf:{help mf_issamefile:issamefile()}}{...}
{col 22}{cmd:issamefile()}{...}
{col 43}whether two file paths point to 
{col 45}the same file 

{col 5}   {c TLC}{hline 10}{c TRC}
{col 5}{hline 3}{c RT}{it: File I/O }{c LT}{hline}
{col 5}   {c BLC}{hline 10}{c BRC}

{col 7}{bf:{help mf_fopen:fopen()}}{...}
{col 22}{cmd:fopen()}{...}
{col 43}open file
{col 22}{cmd:fclose()}{...}
{col 43}close file
{col 22}{cmd:fget()}{...}
{col 43}read line of text file
{col 22}{cmd:fgetnl()}{...}
{col 43}same, but include newline character
{col 22}{cmd:fread()}{...}
{col 43}read {it:k} bytes of binary file
{col 22}{cmd:fput()}{...}
{col 43}write line into text file
{col 22}{cmd:fwrite()}{...}
{col 43}write {it:k} bytes into binary file
{col 22}{cmd:fgetmatrix()}{...}
{col 43}read matrix
{col 22}{cmd:fputmatrix()}{...}
{col 43}write matrix
{col 22}{cmd:fstatus()}{...}
{col 43}status of last I/O command
{col 22}{cmd:ftell()}{...}
{col 43}report location in file
{col 22}{cmd:fseek()}{...}
{col 43}seek to location in file
{col 22}{cmd:ftruncate()}{...}
{col 43}truncate file at current position

{col 7}{bf:{help mf_ferrortext:ferrortext()}}{...}
{col 22}{cmd:ferrortext()}{...}
{col 43}error text of file error code
{col 22}{cmd:freturncode()}{...}
{col 43}return code of file error code

{* begin -- undocumented -- }{...}
{col 7}{bf:{help mf_st_freadsignature:st_freadsignature()}}
{col 22}{cmd:st_freadsignature()}{...}
{col 43}read file signature header
{col 22}{cmd:st_fwritesignature()}{...}
{col 43}write file signature header
{* end -- undocumented -- }{...}

{col 7}{bf:{help mf_bufio:bufio()}}{...}
{col 22}{cmd:bufio()}{...}
{col 43}initialize buffer
{col 22}{cmd:bufbyteorder()}{...}
{col 43}reset (specify) byte order
{col 22}{cmd:bufmissingvalue()}{...}
{col 43}reset (specify) missing-value
{col 45}encoding
{col 22}{cmd:bufput()}{...}
{col 43}copy into buffer
{col 22}{cmd:bufget()}{...}
{col 43}copy from buffer
{col 22}{cmd:fbufput()}{...}
{col 43}copy into and write buffer
{col 22}{cmd:fbufget()}{...}
{col 43}read and copy from buffer
{col 22}{cmd:bufbfmtlen()}{...}
{col 43}utility routine
{col 22}{cmd:bufbfmtisnum()}{...}
{col 43}utility routine

{* st_fopen is undocumented, do not include in manuals}{...}
{col 7}{bf:{help mf_st_fopen:st_fopen()}}{...}
{col 22}{cmd:st_fopen()}{...}
{col 43}open file the Stata way

{col 7}{bf:{help mf_xl:xl()}}{...}
{col 22}{cmd:xl()}{...}
{col 43}Excel file I/O class

{col 7}{bf:{help mf__docx:_docx*()}}{...}
{col 22}{cmd:_docx*()}{...}
{col 43}generate Office Open XML file

{col 7}{bf:{help mf_pdf:Pdf*()}}{...}
{col 22}{cmd:Pdf*()}{...}
{col 43}create a PDF file

{col 5}   {c TLC}{hline 30}{c TRC}
{col 5}{hline 3}{c RT}{it: Filename & path manipulation }{c LT}{hline}
{col 5}   {c BLC}{hline 30}{c BRC}

{col 7}{bf:{help mf_pathjoin:pathjoin()}}{...}
{col 22}{cmd:pathjoin()}{...}
{col 43}join paths
{col 22}{cmd:pathsplit()}{...}
{col 43}split paths
{col 22}{cmd:pathbasename()}{...}
{col 43}path basename
{col 22}{cmd:pathsuffix()}{...}
{col 43}file suffix
{col 22}{cmd:pathrmsuffix()}{...}
{col 43}remove file suffix
{col 22}{cmd:pathisurl()}{...}
{col 43}whether path is URL
{col 22}{cmd:pathisabs()}{...}
{col 43}whether path is absolute
{col 22}{cmd:pathasciisuffix()}{...}
{col 43}whether file is text 
{col 22}{cmd:pathstatasuffix()}{...}
{col 43}whether file is Stata
{col 22}{cmd:pathlist()}{...}
{col 43}process path list
{col 22}{cmd:pathsubsysdir()}{...}
{col 43}substitute for system directories
{col 22}{cmd:pathsearchlist()}{...}
{col 43}path list to search for file
{col 22}{cmd:pathresolve()}{...}
{col 43}resolve a relative path
{col 22}{cmd:pathgetparent()}{...}
{col 43}get the parent path
    {hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions have to do with 

{p 8 12 2}
1.  Displaying output at the terminal.

{p 8 12 2}
2.  Reading and writing data in a file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 IORemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To display the contents of a scalar, vector, or matrix, it is sufficient 
merely to code the identity of the scalar, vector, or matrix:

	: {cmd:x}
        {res}       {txt}          1             2             3             4
            {c TLC}{hline 57}{c TRC}
          1 {c |}  {res}.1369840784    .643220668   .5578016951   .6047949435{txt}  {c |}
            {c BLC}{hline 57}{c BRC}{txt}

{p 4 4 2}
You can follow this approach even in programs:

	{cmd}function example() 
	{
		...
		"i am about to calculate the result"
		...
		"the result is"
		b
	}{txt}

{p 4 4 2}
On the other hand, {cmd:display()} and {cmd:printf()} (see
{bf:{help mf_display:[M-5] display()}} and 
{bf:{help mf_printf:[M-5] printf()}})
will allow you to exercise more control over how the output looks.

{p 4 4 2}
Changing the subject:
you will find that many I/O functions come in two varieties: with and without 
an underscore in front of the name, such as {cmd:_fopen()} and {cmd:fopen()}.
As always, 
functions that begin with an underscore are generally silent about
their work and return flags indicating their success or failure.  Functions
that omit the underscore abort and issue the appropriate error
message when things go wrong.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2009.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0049":Mata Matters: File processing}.
{it:Stata Journal} 9: 599-620.
{p_end}
