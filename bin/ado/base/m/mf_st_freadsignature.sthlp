{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ferrortext()" "help mf_ferrortext"}{...}
{vieweralsosee "[M-5] fopen()" "help mf_fopen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_st_freadsignature##syntax"}{...}
{viewerjumpto "Description" "mf_st_freadsignature##description"}{...}
{viewerjumpto "Remarks" "mf_st_freadsignature##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_freadsignature##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_freadsignature##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_freadsignature##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] st_freadsignature()} {hline 2} Read/write standard Stata file signature


{marker syntax}{...}
{title:Syntax}


{p 8 45 2}
{it:void}
{cmd:st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:f_ver}[{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}]{cmd:)}

{p 8 8 2}
{it:void}
{cmd:st_fwritesignature(}{it:fh}{cmd:,} 
{it:id}{cmd:,} 
{it:ver}{cmd:)}


{p 8 45 2}
{it:real scalar}
{cmd:_st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:,}{break}
{it:f_ver}[{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}]{cmd:)}

{p 8 8 2}
{it:real scalar}
{cmd:_st_fwritesignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:)}


{p 4 4 2}
where

	{it:input:}
		     {it:fh}:  {it:real scalar}   file handle from {cmd:fopen()}
		     {it:id}:  {it:string scalar} filetype name
		    {it:ver}:  {it:real scalar}   version number
		{it:quietly}:  {it:real scalar}   0 or 1

	{it:output:}
		 {it:f_ver}:   {it:real scalar}   version number 
	   {it:f_byteorder}:   {it:real scalar}   1 or 2{col 67}{it:(optional)}
	        {it:f_date}:   {it:real scalar}   {cmd:%tc} date-time{col 67}{it:(optional)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_freadsignature()} reads a standard Stata binary-file signature written
by {cmd:st_fwritesignature()}.  If the file does not match what is expected,
or if I/O errors occur, the function issues the appropriate error message and
cancels execution.  No traceback log is produced.

{pstd}
{cmd:st_fwritesignature()} writes a standard Stata binary-file signature.  If
I/O errors occur, the function issues the appropriate error and cancels
execution.  No traceback log is produced.

{pstd}
{cmd:_st_freadsignature()}
and 
{cmd:_st_fwritesignature()}
do the same but do not cancel execution if an error arises.  They return a
file error code, which will be 0 if no error occurred.  See
{bf:{help mf_ferrortext:[M-5] ferrortext()}} for a description of file error
codes.  These functions can return any of the error codes but, for 
{cmd:_st_freadsignature()}, if it is simply a matter of the file not having
the expected signature (the file not being of the expected type), the error
code will be -610 (file not Stata format).


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help mf_st_freadsignature##overview:Overview}
	{help mf_st_freadsignature##write:st_fwritesignature() and _st_fwritesignature()}
	{help mf_st_freadsignature##read:st_freadsignature() and _st_freadsignature()}


{marker overview}{...}
{title:Overview}

{pstd}
Some commands of Stata need to pass information from one invocation of Stata
to the next
by using files.  Examples of such use in Stata include {cmd:.dta}, datasets;
{cmd:.gph}, graph files; {cmd:.ster}, estimation-result files; and
{cmd:.dtasig}, data-signature files.  All of these examples share the following
characteristics:

{p 8 12 2}
1.  They are binary (contents are not human readable).

{p 8 12 2}
2.  The commands that use the files know when the file is not 
    one of the appropriate type.  For instance, type {cmd:use} {cmd:myfile}
    and, if the file does not contain a Stata dataset, the appropriate error
    message is issued.

{p 8 12 2}
3.  Whether the files are appropriate is not determined by 
    the files' suffix.  For instance, type {cmd:use} {cmd:myfile.dta} and
    even though the filename makes the file appear to be a Stata dataset, if
    it is not, that will be detected.  Type {cmd:use} {cmd:myfile.log} and
    even though the filename makes it appear that the file is not 
    a Stata dataset, if the file
    contains a Stata dataset, {cmd:use} will load it.

{p 8 12 2}
4.  The files work across computers with different byte orders even 
    though they contain binary information.

{p 8 12 2}
5.  Older files continue to be usable.
    For instance, the way results are stored in {cmd:.dta} datasets has
    changed over time as new features have been added to Stata, and yet modern
    Statas continue to be able to read old-format files.

{p 8 12 2}
6.  Stata commands know their limitations.  If you try to {cmd:use}
    {cmd:myfile.dta} with Stata 18 but {cmd:myfile.dta} was created 
    by Stata 42, the appropriate error message will be issued.

{pstd}
This is all accomplished by a file signature, a short piece of data 
at the top of the file that identifies the type of file, the version 
that wrote it, and the byte order.

{pstd}
Say that you are writing a system the creates and later reads 
{cmd:.xyz} files.  You could accomplish the above by creating 
your own data signature.  When you write a file, you could start with 
the code 

		{cmd:fh = fopen(}...{cmd:)}
		{cmd}sig = sprintf("xyz %1.0f %04.0f", byteorder(), 1)
		fwrite(fh, sig, 10){txt}

{pstd}
When you read a file, you would start like this 

		{cmd:fh = fopen(}...{cmd:)}
		{cmd}sig = fread(fh, 10)
		if (substr(sig, 1, 4)!="xyz ") { 
			fclose(fh)
			errprintf("file not xyz file\n")
			exit(610)
		}
		border = strtoreal(substr(sig, 5, 1))
		ver    = strtoreal(substr(sig, 7, 4))
		if (ver!=1) { 
			fclose(fh)
			errprintf("file too new\n") 
			exit(610)
		}{txt}

{pstd}
That is a reasonable solution, except that "xyz 2 0001"
is not an especially unlikely string and you should work on improving it.

{pstd}
The functions here write a better signature, better because (1) it is longer and
therefore less likely to be confused with something else and (2) 
it contains more information.  The functions provided here are also easier to
use.

{pstd}
To write a file, you code 

		{cmd:fh = fopen(}...{cmd:)}
		{cmd}st_fwritesignature(fh, "xyz", 1){txt}

{pstd}
To read it, you code

		{cmd:fh = fopen(}...{cmd:)}
		{cmd}st_freadsignature(fh, "xyz", 1, ver, border){txt}

{pstd}
You do not have to bother coding the appropriate error messages because 
that is all handled for you.  The signature that would be written would
look like

	{cmd}*! Stata(R) 010.00 Binary File Header_version 0010
	*! Date 22feb2007 10:46:10
	*! Byteorder LOHI
	*! Filetype xyz                              Version 0001
	*! <end_of_header>
	1
	2
	3{txt}

{pstd}
The lines all end with carriage return line feed, except {cmd:1}, which ends
with just carriage return, and {cmd:2}, which ends with just line feed.  The
purpose of this is to allow {cmd:st_freadsignature()} to test whether the
binary file has inappropriately been run though an ASCII end-of-line
conversion routine and to issue the appropriate message if it has.

{pstd}
StataCorp is moving toward having all binary files created by Stata use this 
standard header.  As of Stata 11, {cmd:.dta} and {cmd:.gph} files do not 
yet use this header.


{marker write}{...}
{title:st_fwritesignature() and _st_fwritesignature()}

{pstd}
The syntax of {cmd:st_fwritesignature()} is

{p 8 12 2}
{it:void}
{cmd:st_fwritesignature(}{it:fh}{cmd:,} 
{it:id}{cmd:,} 
{it:ver}{cmd:)}:

{p 8 12 2}
{it:fh} specifies the file handle of the already open file.

{p 8 12 2}
{it:id} specifies a string of up to 32 characters that identifies the type of
file being written.  This string can also be used in error messages of the
type "file not {it:id}" and "file is {it:id}", so choose an
identifier that works well with them; {it:id} should not
contain the word "file".  
{it:id} might be {cmd:"output} {cmd:table"}.
Longer identifiers are better than shorter ones.

{p 8 12 2}
{it:ver} must be an integer between 1 and 9,999 and specifies the version of
the file-writing software.  This is the version of the software you are
writing and so initially, it will be 1.  If you later change the way you
write files, increment this number.


{pstd}
The syntax of {cmd:_st_fwritesignature()} is

{p 8 8 2}
{it:real scalar}
{cmd:_st_fwritesignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:)}

{p 8 12 2}
{it:fh}, {it:id}, and {it:ver} are as described above.

{p 8 12 2}
{it:quietly} is optional and should be 0 or 1; 1 indicates that 
error messages are not to be displayed.

{p 8 12 2}
{cmd:_st_fwritesignature()} returns a file error code, which is 0 
or a negative integer; see
{bf:{help mf_ferrortext:[M-5] ferrortext()}}.


{marker read}{...}
{title:st_freadsignature() and _st_freadsignature()}

{pstd}
The syntax of {cmd:st_freadsignature()} is

{p 8 45 2}
{it:void}
{cmd:st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:f_ver}[{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}]{cmd:)}

{p 8 12 2}
{it:fh} specifies the file handle of the already open file.

{p 8 12 2}
{it:id} specifies the string of up to 32 characters that identifies the
    type of file being read.  This is the same {it:id} that was specified with
    {cmd:st_fwritesignature()}.  If the {it:id} specified does not match the
    {it:id} in the header, an error message will be issued and execution
    canceled.

{p 8 12 2}
{it:ver} must be an integer between 1 and 9,999 and specifies the highest
    version of the file that your code is prepared to read.  If {it:ver}
    specified is less than {it:ver} in the file, the appropriate file-too-new
    error message will be issued and execution canceled.

{p 8 12 2}
{it:f_ver} receives a returned result; its original contents are irrelevant.
    {it:f_ver} will contain 
    the {it:ver} recorded in the file header.
    It is guaranteed that {it:f_ver} <= {it:ver}.

{p 8 12 2}
{it:f_byteorder} is optional.  
{it:f_byteorder} receives a returned result; its original contents 
are irrelevant.
{it:f_byteorder} will contain 1 or 2,
reflecting the byte order on the computer by which the file was written; see
{bf:{help mf_byteorder:[M-5] byteorder()}}.

{p 8 12 2}
{it:f_date} is optional.
{it:f_date} receives a returned result; its original contents 
are irrelevant.
{it:f_date} will contain a number equal to the {cmd:%tc} format date 
on which the file was written.

{p 8 12 2}
{cmd:_st_freadsignature()} returns a file error code, which is 0 
or a negative integer; see
{bf:{help mf_ferrortext:[M-5] ferrortext()}}.


{pstd}
The syntax of {cmd:_st_freadsignature()} is

{p 8 45 2}
{it:real scalar}
{cmd:_st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:,}{break}
{it:f_ver}[{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}]{cmd:)}

{p 8 12 2}
{it:fh},
{it:id},
{it:ver},
{it:f_ver},
{it:f_byteorder},
and
{it:f_date} are as described above, except that, any place it was 
mentioned that an error message would be issued and execution canceled, 
rather than execution being canceled, a negative file error code 
will be returned; see 
{bf:{help mf_ferrortext:[M-5] ferrortext()}}.

{p 8 12 2}
{it:quietly} is optional and should be 0 or 1; 1 indicates that 
error messages are not to be displayed.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:f_ver}{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}{cmd:)}:
{p_end}
	{it:input:}
	       {it:fh}:  1 {it:x} 1
	       {it:id}:  1 {it:x} 1
	      {it:ver}:  1 {it:x} 1
	{it:output:}
	    {it:f_ver}:  1 {it:x} 1
      {it:f_byteorder}:  1 {it:x} 1    (optional)
           {it:f_date}:  1 {it:x} 1    (optional)

{p 4 4 2}
{cmd:_st_freadsignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:,}
{it:f_ver}{cmd:,}
{it:f_byteorder}{cmd:,}
{it:f_date}{cmd:)}:
{p_end}
	{it:input:}
	       {it:fh}:  1 {it:x} 1
	       {it:id}:  1 {it:x} 1
	      {it:ver}:  1 {it:x} 1
	  {it:quietly}:  1 {it:x} 1
	{it:output:}
	    {it:f_ver}:  1 {it:x} 1
      {it:f_byteorder}:  1 {it:x} 1    (optional)
           {it:f_date}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:st_fwritesignature(}{it:fh}{cmd:,} 
{it:id}{cmd:,} 
{it:ver}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	       {it:id}:  1 {it:x} 1
	      {it:ver}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_st_fwritesignature(}{it:fh}{cmd:,}
{it:id}{cmd:,}
{it:ver}{cmd:,}
{it:quietly}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	       {it:id}:  1 {it:x} 1
	      {it:ver}:  1 {it:x} 1
	  {it:quietly}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions abort with error when misused.

{p 4 4 2}
{cmd:st_fwritesignature()} and 
{cmd:st_freadsignature()} 
issue error messages and cancel execution 
when file errors occur or when the file does not match what is expected.
No traceback log is produced.

{p 4 4 2}
{cmd:_st_fwritesignature()} and 
{cmd:_st_freadsignature()} 
do not cancel execution in those cases; a negative file error code 
is returned.

{p 4 4 2}
In professional applications, it is usually necessary to use the underscore 
variants of the functions.  That is not true here if the 
desire is simply to cancel execution.  These functions do not 
produce traceback logs unless used incorrectly.

{p 4 4 2}
If you use the underscore functions, you must close the file if a nonzero
value is returned; the underscore functions do not do that for you.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_fsignature.mata, adopath asis:st_fsignature.mata} for all functions.
{p_end}
