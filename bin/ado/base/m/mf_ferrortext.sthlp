{smcl}
{* *! version 1.1.5  26apr2019}{...}
{vieweralsosee "[M-5] ferrortext()" "mansection M-5 ferrortext()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fopen()" "help mf_fopen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_ferrortext##syntax"}{...}
{viewerjumpto "Description" "mf_ferrortext##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ferrortext##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ferrortext##remarks"}{...}
{viewerjumpto "Conformability" "mf_ferrortext##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ferrortext##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ferrortext##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] ferrortext()} {hline 2}}Text and return code of file error code
{p_end}
{p2col:}({mansection M-5 ferrortext():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:string scalar}
{cmd:ferrortext(}{it:real scalar ec}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:freturncode(}{it:real scalar ec}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ferrortext(}{it:ec}{cmd:)}
returns the text associated with a file error code returned by, for instance,
{cmd:_fopen()}, {cmd:_fwrite()}, {cmd:fstatus()}, or any other
file-processing functions that return an error code.
See {bf:{help mf_fopen:[M-5] fopen()}}.

{p 4 4 2}
{cmd:freturncode(}{it:ec}{cmd:)}
returns the Stata return code associated with the file error code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ferrortext()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Most file-processing functions abort with error if something goes wrong.  You
attempt to read a nonexisting file, or attempt to write a read-only file, and
the file functions you use to do that, usually documented in 
{bf:{help mf_fopen:[M-5] fopen()}}, abort with error.  Abort with error means
not only that the file function you called stops when the error arises but
also that the calling function is aborted.  The user is presented with a
traceback log documenting what went wrong.

{pstd}
Sometimes you will want to write code to handle such errors for itself. 
For instance, you are writing a subroutine for a command to be used 
in Stata and, if the file does not exist, you want the subroutine 
to present an informative error message and exit without a traceback log but
with a nonzero return code.  Or in another application, if the file does not
exist, that is not an error at all; your code will create the file.

{pstd}
Most file-processing functions have a corresponding underscore function that,
rather than aborting, returns an error code when things go wrong.
{cmd:fopen()} opens a file or aborts with error.  {cmd:_fopen()} opens a file
or returns an error code.  The error code is sufficient for your program to
take the appropriate action.  One uses the underscore functions when 
the calling program will deal with any errors that might arise.

{pstd}
Let's take the example of simply avoiding traceback logs.
If you code

		{cmd:fh = fopen(filename, "r")}

{pstd} 
and the file does not exist, execution aborts and you see a traceback
log.  If you code

		{cmd}if ((fh = _fopen(filename, "r"))<0) {c -(}
			errprintf("%s\n", ferrortext(fh))
			exit(freturncode(fh))
		{c )-}{txt}

{pstd}
execution still stops if the file does not exist, but this time, it stops
because you coded {helpb mf_exit:exit()}.  You still see an error message, but
this time, you see the message because you coded
{helpb mf_errprintf:errprintf()}.  No traceback log is produced because you did
not insert code to produce one.  You could have coded {cmd:_exit()} if you
wanted one.

{pstd}
The file error codes and the messages associated with them are

       Negative
	 code    Meaning
	{hline 61}
	    0    all is well
	   -1    end of file {it:(this code is usually not an error)}

	 -601    file not found
	 -602    file already exists
	 -603    file could not be opened
	 -608    file is read-only

	 -610    file not Stata format
	 -612    unexpected end of file

	 -630    web files not supported by this version of Stata
	 -631    host not found
	 -632    web file not allowed in this context
	 -633    may not write to web file
	 -639    file transmission error -- checksums do not match

	 -660    proxy host not found
	 -662    proxy server refused request to send
	 -663    remote connection to proxy failed
	 -665    could not set socket nonblocking
	 -667    wrong version of {cmd:winsock.dll}
	 -668    could not find valid {cmd:winsock.dll} or {cmd:astsys0.lib}
	 -669    invalid URL

	 -670    invalid network port number
	 -671    unknown network protocol
	 -672    server refused to send file
         -673    authorization required by server
	 -674    unexpected response from server
	 -675    server reported error
	 -676    server refused request to send
	 -677    remote connection failed -- see {cmd:r(677)} for troubleshooting
	 -678    could not open local network socket
	 -679    unexpected web error

	 -680    could not find valid {cmd:odbc32.dll}
	 -681    too many open files
	 -682    could not connect to ODBC data source name
	 -683    could not fetch variable in ODBC table
	 -684    could not find valid {cmd:dlxabi32.dll}

	 -691    I/O error
         -699    insufficient disk space

	-3601    invalid file handle
	-3602    invalid filename
	-3611    too many open files
	-3621    attempt to write read-only file
	-3622    attempt to read write-only file
	-3623    attempt to seek append-only file
	-3698    file seek error
	{hline 61}

{pstd}
File error codes are usually negative, but neither
{cmd:ferrortext(}{it:ec}{cmd:)} nor {cmd:freturncode(}{it:ec}{cmd:)} cares
whether {it:ec} is of the positive or negative variety.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:ferrortext(}{it:ec}{cmd:)},
{cmd:freturncode(}{it:ec}{cmd:)}:
{p_end}
	       {it:ec}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ferrortext(}{it:ec}{cmd:)}
and 
{cmd:freturncode(}{it:ec}{cmd:)} treat {it:ec} = -1 (end of file)
the same 
as {it:ec} = 612 (unexpected end of file).  
Code -1 usually is not an error; it just denotes 
end of file.  It is assumed that you will not call 
{cmd:ferrortext()} and {cmd:freturncode()} in such cases.
If you do call the functions here, it is assumed that you mean 
that the end of file was unexpected.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ferrortext.mata, adopath asis:ferrortext.mata} for both functions.
{p_end}
