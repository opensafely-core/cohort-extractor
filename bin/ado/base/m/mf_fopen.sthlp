{smcl}
{* *! version 1.1.13  26apr2019}{...}
{vieweralsosee "[M-5] fopen()" "mansection M-5 fopen()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] bufio()" "help mf_bufio"}{...}
{vieweralsosee "[M-5] cat()" "help mf_cat"}{...}
{vieweralsosee "[M-5] printf()" "help mf_printf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_fopen##syntax"}{...}
{viewerjumpto "Description" "mf_fopen##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_fopen##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_fopen##remarks"}{...}
{viewerjumpto "Conformability" "mf_fopen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_fopen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_fopen##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] fopen()} {hline 2}}File I/O
{p_end}
{p2col:}({mansection M-5 fopen():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:fopen(}{it:string scalar fn}{cmd:,}
{it:mode}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:fopen(}{it:string scalar fn}{cmd:,}
{it:mode}{cmd:,}
{it:public}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fopen(}{it:string scalar fn}{cmd:,}
{it:mode}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fopen(}{it:string scalar fn}{cmd:,}
{it:mode}{cmd:,}
{it:public}{cmd:)}


{p 4 4 2}
where 
{p_end}
{p 16 18 2}
{help mf_fopen##mode:{it:mode}}:  {it:string scalar} containing "{cmd:r}", "{cmd:w}", "{cmd:rw}", or
"{cmd:a}"

{p 14 18 2}
{help mf_fopen##public:{it:public}}:  optional {it:real scalar} containing zero or nonzero


{p 4 4 2}
In what follows, {it:fh} is the value returned by {cmd:fopen()} or 
{cmd:_fopen()}:

{p 8 8 2}
{it:void}{bind:          }
{cmd:fclose(}{it:fh}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fclose(}{it:fh}{cmd:)}


{p 8 8 2}
{it:string scalar}{bind: }
{cmd:fget(}{it:fh}{cmd:)}

{p 8 8 2}
{it:string scalar}
{cmd:_fget(}{it:fh}{cmd:)}

{p 8 8 2}
{it:string scalar}{bind: }
{cmd:fgetnl(}{it:fh}{cmd:)}

{p 8 8 2}
{it:string scalar}
{cmd:_fgetnl(}{it:fh}{cmd:)}


{p 8 8 2}
{it:string scalar}{bind: }
{cmd:fread(}{it:fh}{cmd:,}
{it:real scalar len}{cmd:)}

{p 8 8 2}
{it:string scalar}
{cmd:_fread(}{it:fh}{cmd:,}
{it:real scalar len}{cmd:)}


{p 8 8 2}
{it:void}{bind:          }
{cmd:fput(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fput(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}


{p 8 8 2}
{it:void}{bind:          }
{cmd:fwrite(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fwrite(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}


{p 8 8 2}
{it:matrix}{bind:        }
{cmd:fgetmatrix(}{it:fh} [{cmd:, }{it:real scalar isstrict}]{cmd:)}

{p 8 8 2}
{it:matrix}{bind:       }
{cmd:_fgetmatrix(}{it:fh} [{cmd:, }{it:real scalar isstrict}]{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:fputmatrix(}{it:fh}{cmd:,}
{it:transmorphic matrix X}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fputmatrix(}{it:fh}{cmd:,}
{it:transmorphic matrix X}{cmd:)}


{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:fstatus(}{it:fh}{cmd:)}


{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:ftell(}{it:fh}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_ftell(}{it:fh}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:fseek(}{it:fh}{cmd:,}
{it:real scalar offset}{cmd:,}
{it:real scalar whence}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_fseek(}{it:fh}{cmd:,}
{it:real scalar offset}{cmd:,}
{it:real scalar whence}{cmd:)}

{p 22 23 2}
({it:whence} is coded -1, 0, or 1, meaning from start of file, from 
current position, or from end of file; {it:offset} is signed:  positive
values mean after {it:whence} and negative values mean before)


{p 8 8 2}
{it:void}{bind:          }
{cmd:ftruncate(}{it:fh}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:  }
{cmd:_ftruncate(}{it:fh}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions read and write files.  First,
open the file and get back a file handle ({it:fh}).  The file handle, which is
nothing more than an integer, is how you refer to the file in the calls to
other file I/O functions.  When you are finished, close the file.

{p 4 4 2}
Most file I/O functions come in two varieties: without and with an 
underscore in front of the name, such as
{help mf_fopen##remarks1:{bf:fopen()} and {bf:_fopen()}}, and
{help mf_fopen##remarks3:{bf:fwrite()} and {bf:_fwrite()}}.

{p 4 4 2}
In functions without a leading underscore, errors cause execution to be
aborted.  For instance, you attempt to open a file for read and the file does
not exist.  Execution stops.  Or, having successfully opened a file, you
attempt to write into it and the disk is full.  Execution stops.  When
execution stops, the appropriate error message is presented.

{p 4 4 2}
In functions with the leading underscore, execution continues and no error
message is displayed; it is your responsibility (1) to verify that things went
well and (2) to take the appropriate action if they did not.  Concerning (1),
some underscore functions return a status value; others require that you call
{helpb mf_fopen##underscore:fstatus()} to obtain the status information.

{p 4 4 2}
You can mix and match use of underscore and nonunderscore functions, 
using, say, {cmd:_fopen()} to open a file and {cmd:fread()} to read it, or 
{cmd:fopen()} to open and {cmd:_fwrite()} to write.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 fopen()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_fopen##remarks1:Opening and closing files}
	{help mf_fopen##remarks2:Reading from a file}
	{help mf_fopen##remarks3:Writing to a file}
	{help mf_fopen##remarks4:Reading and writing in the same file}
	{help mf_fopen##remarks5:Reading and writing matrices}
	{help mf_fopen##remarks6:Repositioning in a file}
	{help mf_fopen##remarks7:Truncating a file}
	{help mf_fopen##remarks8:Error codes}


{marker remarks1}{...}
{title:Opening and closing files}

{p 4 4 2}
Functions 

{p 9 9 2}
{cmd:fopen(}{it:string scalar fn}{cmd:,}
{it:string scalar mode}{cmd:)}

{p 8 8 2}
{cmd:_fopen(}{it:string scalar fn}{cmd:,}
{it:string scalar mode}{cmd:)}

{p 9 9 2}
{cmd:fopen(}{it:string scalar fn}{cmd:,}
{it:string scalar mode}{cmd:,}
{it:real scalar public}{cmd:)}

{p 8 8 2}
{cmd:_fopen(}{it:string scalar fn}{cmd:,}
{it:string scalar mode}{cmd:,}
{it:real scalar public}{cmd:)}

{p 4 4 2}
open a file.  
The file may be on a local disk, a network disk, or even on the 
web (such as https://www.stata.com/index.html). 
{it:fn} specifies the filename, and {it:mode} specifies how the file is to
opened:

{marker mode}{...}
	{it:mode}     Meaning
	{hline 61}
	"{cmd:r}"      Open for reading; file must exist and be readable.
                 File may be "{cmd:https://...}" file.
		 File will be positioned at the beginning.

	"{cmd:w}"      Open for writing; file must not exist and the 
                 directory be writable.
                 File may not be "{cmd:https://...}" file.
		 File will be positioned at the beginning.

        "{cmd:rw}"     Open for reading and writing; file must either 
                 exist and be writable or not exist and directory be
                 writable.
                 File may not be "{cmd:https://...}" file.
		 File will be positioned at the beginning (new file) 
		 or at the end (existing file).

        "{cmd:a}"      Open for appending; file must either exist and be 
                 writable or not exist and directory be writable.
                 File may not be "{cmd:https://...}" file.
		 File will be positioned at the end.
	{hline 61}

{p 4 4 2}
Other values for {it:mode} cause {cmd:fopen()} and {cmd:_fopen()} to 
abort with an invalid-mode error.

{marker public}{...}
{p 4 4 2}
Optional third argument {it:public} specifies whether the file, if it is 
being created, should be given permissions so that everyone can read it, 
or if it instead should be given the normal permissions.
Not specifying {it:public}, or specifying {it:public} as 0, gives the 
file the normal permissions.  Specifying {it:public} as nonzero makes the 
file publicly readable.  {it:public} is relevant only when the file is 
being created, that is, is being opened {cmd:"w"}, or being opened {cmd:"rw"}
and not previously existing.

{p 4 4 2}
{cmd:fopen()} returns a file handle; the file is opened or execution is
aborted.

{p 4 4 2}
{cmd:_fopen()} returns a file handle or returns a negative number.
If a negative number is returned, the file is not open, and the number
indicates the reason.  For {cmd:_fopen()}, there are a few 
likely possibilities

      Negative
	value    Meaning
	{hline 61}
	 -601    file not found
	 -602    file already exists
	 -603    file could not be opened
	 -608    file is read-only
	 -691    I/O error
	{hline 61}

{p 4 4 2}
and there are many other possibilities.
For instance, perhaps you attempted to open a file on the web (say,
https://www.newurl.org/upinfo.doc) and the URL was not found, or the server
refused to send back the file, etc.  See
{it:{help mf_fopen##remarks8:Error codes}} below for a complete
list of codes.

{p 4 4 2}
After opening the file, you use the other file I/O commands to read and write
it, and then you close the file with {cmd:fclose()} or {cmd:_fclose()}.
{cmd:fclose()} returns nothing; if the file cannot be closed, execution is
aborted.  {cmd:_fclose} returns 0 if successful, or a negative number
otherwise.  For {cmd:_fclose()}, the likely possibilities are

      Negative
	value    Meaning
	{hline 61}
         -691    filesystem I/O error
	{hline 61}


{marker remarks2}{...}
{title:Reading from a file}

{p 4 4 2}
You may read from a file opened "{cmd:r}" or "{cmd:rw}".
The commands to read are

{p 9 8 2}
{cmd:fget(}{it:fh}{cmd:)}

{p 9 8 2}
{cmd:fgetnl(}{it:fh}{cmd:)}

{p 9 8 2}
{cmd:fread(}{it:fh}{cmd:,}
{it:real scalar len}{cmd:)}

{p 4 4 2}
and, of course, 

{p 8 8 2}
{cmd:_fget(}{it:fh}{cmd:)}

{p 8 8 2}
{cmd:_fgetnl(}{it:fh}{cmd:)}

{p 8 8 2}
{cmd:_fread(}{it:fh}{cmd:,}
{it:real scalar len}{cmd:)}

{p 4 4 2}
All functions, with or without an underscore, require a file handle be
specified, and all the functions return a string scalar or they return
{cmd:J(0,0,"")}, a 0 {it:x} 0 string matrix.  They return {cmd:J(0,0,"")} 
on end of
file and, for the underscore functions, when the read was not
successful for other reasons.  When using the underscore functions, you use
{cmd:fstatus()} to obtain the status code; see
{it:{help mf_fopen##remarks8:Error codes}} below.
The underscore read functions are rarely used because the only reason a 
read can fail is I/O error, and there is not much that can be done 
about that except abort, which is exactly what the nonunderscore functions
do.

{p 4 4 2}
{cmd:fget(}{it:fh}{cmd:)} is for reading text files; the next line from the
file is returned, without end-of-line characters.
(If the line is longer then 32,768 characters, the first 32,768 characters 
are returned.)

{p 4 4 2}
{cmd:fgetnl(}{it:fh}{cmd:)} is much the same as {cmd:fget()}, except that the
new-line characters are not removed from the returned result.
(If the line is longer then 32,768 characters, the first 32,768 characters 
are returned.)

{p 4 4 2}
{cmd:fread(}{it:fh}{cmd:,} {it:len}{cmd:)} is usually used for reading binary
files and returns the next {it:len} characters (bytes) from the file or, if
there are fewer than that remaining to be read, however many remain.
({it:len} may not exceed 9,007,199,254,740,991 [{it:sic}] on 64-bit computers;
memory shortage for storing the result will arise long before this limit is
reached on most computers.)

{p 4 4 2}
The following code reads and displays a file:

	{cmd}fh = fopen(filename, "r")
	while ((line=fget(fh))!=J(0,0,"")) {
		printf("%s\n", line) 
	}
	fclose(fh){txt}


{marker remarks3}{...}
{title:Writing to a file}

{p 4 4 2}
You may write to a file opened "{cmd:w}", "{cmd:rw}", or "{cmd:a}".
The functions are 

{p 9 8 2}
{cmd:fput(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 9 8 2}
{cmd:fwrite(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 4 4 2}
and, of course, 

{p 8 8 2}
{cmd:_fput(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 8 8 2}
{cmd:_fwrite(}{it:fh}{cmd:,}
{it:string scalar s}{cmd:)}

{p 4 4 2}
{it: fh} specifies the file handle, and {it:s} specifies the string to be
written.  {cmd:fput()} writes {it:s} followed by the new-line characters
appropriate for your operating system.  {cmd:fwrite()} writes {it:s} alone.

{p 4 4 2}
{cmd:fput()} and {cmd:fwrite()} return nothing; {cmd:_fput()} and 
{cmd:_fwrite()} return a real scalar equal to 0 if all went well, or a 
negative error code; see
{it:{help mf_fopen##remarks8:Error codes}} below.

{p 4 4 2}
The following code copies text from one file to another:

	{cmd}fh_in  = fopen(inputname, "r")
	fh_out = fopen(outputname, "w")
	while ((line=fget(fh_in))!=J(0,0,"")) {
		fput(fh_out, line)
	}
	fclose(fh_out)
	fclose(fh_in){txt}

{p 4 4 2}
The following code reads a file (binary or text) and changes every 
occurrence of "a" to "b":

	{cmd}fh_in  = fopen(inputname, "r")
	fh_out = fopen(outputname, "w")
	while ((c=fread(fh_in, 1))!=J(0,0,"")) {
		fwrite(fh_out, (c=="a" ? "b" : c))
	}
	fclose(fh_out)
	fclose(fh_in){txt}


{marker remarks4}{...}
{title:Reading and writing in the same file}

{p 4 4 2}
You may read and write from a file opened "{cmd:rw}", using any of the read or
write functions described above.  When reading and writing in the same file,
one often uses file repositioning functions, too;
see {it:{help mf_fopen##remarks6:Repositioning in a file}} below.


{marker remarks5}{...}
{title:Reading and writing matrices}

{p 4 4 2}
Functions 

{p 8 4 2}
{cmd:fputmatrix(}{it:fh}{cmd:,}
{it:transmorphic matrix X}{cmd:)}

{p 4 4 2}
and 

{p 7 4 2}
{cmd:_fputmatrix(}{it:fh}{cmd:,}
{it:transmorphic matrix X}{cmd:)}

{p 4 4 2}
will write a matrix to a file.  In the usual fashion, {cmd:fputmatrix()}
returns nothing (it aborts if there is an I/O error) and {cmd:_fputmatrix()}
returns a scalar equal to 0 if all went well and a negative error code
otherwise.

{p 4 4 2}
Functions

{p 8 4 2}
{cmd:fgetmatrix(}{it:fh} [{cmd:, }{it:real scalar isstrict}]{cmd:)}

{p 4 4 2}
and

{p 7 4 2}
{cmd:_fgetmatrix(}{it:fh} [{cmd:, }{it:real scalar isstrict}]{cmd:)}

{p 4 4 2}
will read a matrix written by {cmd:fputmatrix()} or {cmd:_fputmatrix()}.  Both
functions return the matrix read or return {cmd:J(0,0,.)} on end of file
(both functions) or error ({cmd:_fgetmatrix()} only).  Because {cmd:J(0,0,.)}
could be the matrix that was written, distinguishing between that and
end of file requires subsequent use of
{helpb mf_fopen##underscore:fstatus()}.  {cmd:fstatus()} will
return 0 if {cmd:fgetmatrix()} or {cmd:_fgetmatrix()} returned a written
matrix, -1 if end of file, or (after {cmd:_fgetmatrix()}) a negative error
code.

{p 4 4 2}
For a Mata struct or class matrix, a matrix according to the current
definition will be created, and the saved matrix will be used to initialize
the new matrix based on member-name matching.

{p 4 4 2}
Optional argument {it:isstrict} affects the behavior of the functions if the
matrix being read is a Mata struct or class matrix.  When the argument is set
and not zero, the current struct or class definition in memory will be checked
against the saved matrix to ensure that all variable names, variable eltypes,
and variable orgtypes match each other.

{p 4 4 2}
{cmd:fputmatrix()} writes matrices in a compact, efficient, and portable
format; a matrix written on a Windows computer can be read back on a Mac
or Unix computer and vice versa.

{p 4 4 2}
The following code creates a file containing three matrices,

	{cmd}fh = fopen(filename, "w")
	fputmatrix(fh, a) 
	fputmatrix(fh, b) 
	fputmatrix(fh, c) 
	fclose(fh){txt}

{p 4 4 2}
and the following code reads them back:

	{cmd}fh = fopen(filename, "r")
	a = fgetmatrix(fh) 
	b = fgetmatrix(fh) 
	c = fgetmatrix(fh) 
	fclose(fh){txt}

{p 4 4 2}
The following code saves a Mata class scalar to file,

	{cmd}class sA {
		real scalar r
		string scalar s
		static scalar sr
		void new()
	}
	
	a = sA()
	a.r = 1
	a.s = "sA instance"
	
	fh = fopen(filename, "w")	
	fputmatrix(fh, a) 
	fclose(fh){txt}

{p 4 4 2}
and the following code reads the class matrix back:

	{cmd}fh = fopen(filename, "r")
	a = fgetmatrix(fh) 
	fclose(fh){txt}

{p 4 4 2}
The contents of {cmd:a} depends on the current definition of class {cmd:sA}
in memory.  If the definition does not change, {cmd:a.r} will be 1 and  
{cmd:a.s} will be "sA instance".  Note: Only regular variables are saved and 
read back; static variables and functions are not saved.  Also, the {cmd:new()}
function will not be called in the created class scalar.  If the class 
definition has been changed,

	{cmd}class sA {
		real scalar r
		real scalar b
		static scalar sr
		void new()
	}{txt}

{p 4 4 2}
the function will not read the matrix if optional argument {it:isstrict} is
specified and not zero.  Otherwise, a class {cmd:sA} scalar {cmd:a} according
to the current definition will be created.  (Note: {cmd:new()} will not be
called.)  Member variables with matching names and compatible eltypes and
orgtypes will be initialized using the values in the saved matrix.  In this
example, {cmd:a.r} will be {cmd:1}, and {cmd:a.b} will be missing because
{cmd:b} is not a member in the class {cmd:sA} definition when it was saved.

		
	{hline}
	{title:Technical note}

{p 8 8 2}
You may even write pointer matrices

	    {cmd}mats = (&a, &b, &c, NULL)
	    fh = fopen(filename,"w") 
	    fputmatrix(fh, mats)
	    fclose(fh){txt}

{p 8 8 2}
and read them back:

	    {cmd}fh = fopen(filename, "r")
	    mats = fgetmatrix(fh)
	    fclose(fh){txt}

{p 8 8 2}
When writing pointer matrices, {cmd:fputmatrix()} writes NULL for any
pointer-to-function value.  It is also recommended that you do not
write self-referential matrices (matrices that point to themselves, either
directly or indirectly), although the elements of the matrix may be cross
linked and even recursive themselves.  If you are writing pointer
matrix {cmd:p}, no element of {cmd:p}, {cmd:*p}, {cmd:**p},
etc., should contain {cmd:&p}.  That one address cannot be preserved 
because in the assignment associated with reading back the matrix (the
"{it:result} {cmd:=}" part of {it:result} {cmd:= fgetmatrix(fh)}),
a new matrix with a different address is associated with the contents.
{p_end}
	{hline}


{marker remarks6}{...}
{title:Repositioning in a file}

{p 4 4 2}
The function 

{p 8 8 2}
{cmd:ftell(}{it:fh}{cmd:)}

{p 4 4 2} 
returns a real scalar reporting where you are in a file, and function

{p 8 8 2}
{cmd:fseek(}{it:fh}{cmd:,}
{it:real scalar offset}{cmd:,}
{it:real scalar whence}{cmd:)}

{p 4 4 2}
changes where you are in the file to be 
{it:offset} bytes from the 
beginning of the file ({it:whence} = -1), 
{it:offset} bytes from the current position ({it:whence} = 0), 
or {it:offset} bytes from the end of the file ({it:whence} = 1).

{p 4 4 2}
Functions {cmd:_ftell()} and {cmd:_fseek()} do the same thing as 
{cmd:ftell()} and {cmd:fseek()}, the difference being that, rather 
than aborting on error, the underscore functions return negative error
codes.  {cmd:_ftell()} is pretty well useless as the only error that 
can arise is I/O error, and what else are you going to do other than abort?
{cmd:_fseek()}, however, has a use, because it allows you to try out a 
repositioning and check whether it was successful.  With {cmd:fseek()}, 
if the repositioning is not successful, execution is aborted.

{p 4 4 2}
Say that you open a file for read

	{cmd:fh = fopen(filename, "r")}

{p 4 4 2}
After opening the file in mode "{cmd:r}", you are positioned at the beginning
of the file or, in the jargon of file processing, at position 0.
Now say that you read 10 bytes from the file:

	{cmd:part1 = fread(fh, 10)}

{p 4 4 2}
Assuming that was successful, you are now at position 10 of the file.
Say you next read a line from the file 

	{cmd:line = fget(fh)}

{p 4 4 2}
and assume that {cmd:fget()} returns "abc".  You are now at position 14 or 
15.  (No, not 13:  {cmd:fget()} read the line and the new-line characters
and returned the line.  "abc" was followed by carriage return and line feed
(two characters) if the file was written under Windows and 
by a carriage return or line feed alone
(one character) if the file was written under Mac or Unix).

{p 4 4 2}
{cmd:ftell(}{it:fh}{cmd:)} and {cmd:_ftell(}{it:fh}{cmd:)} tell you where you
are in the file.  Coding

	{cmd:pos = ftell(fh)}

{p 4 4 2}
would store 14 or 15 in {cmd:pos}.  Later in your code, after reading more
of the file, you could return to this position by coding 

	{cmd:fseek(fh, pos, -1)}

{p 4 4 2}
You could return to the beginning of the file by coding 

	{cmd:fseek(fh, 0, -1)}

{p 4 4 2} 
and you could move to the end of the file by coding 

	{cmd:fseek(fh, 0, 1)}

{p 4 4 2}
{cmd:_fseek(}{it:fh}{cmd:, 0, 0)}  is equivalent to
{cmd:ftell(}{it:fh}{cmd:)}.

{p 4 4 2}
Repositioning functions cannot be used when the file has been opened
"{cmd:a}".


{marker remarks7}{...}
{title:Truncating a file}

{p 4 4 2}
Truncation refers to making a longer file shorter.  
If a file was opened "{cmd:w}" or "{cmd:rw}", you may truncate it at its
current position by using

{p 9 8 2}
{cmd:ftruncate(}{it:fh}{cmd:)}

{p 4 4 2}
or

{p 8 8 2}
{cmd:_ftruncate(}{it:fh}{cmd:)}

{p 4 4 2}
{cmd:ftruncate()} returns nothing; {cmd:_ftruncate()} returns 0 on success
and otherwise returns a negative error code.

{p 4 4 2}
The following code shortens a file to its first 100 bytes:

	{cmd}fh = fopen(filename, "rw")
	fseek(fh, 100, -1)
	ftruncate(fh)
	fclose(fh){txt}


{marker remarks8}{...}
{title:Error codes}

{p 4 4 2}
If you use the underscore I/O functions, if there is an error, they 
will return a negative code.  Those codes are

       Negative
	 code    Meaning
	{hline 61}
	    0    all is well
	   -1    end of file
	   -2    connection timed out
	 -601    file not found
	 -602    file already exists
	 -603    file could not be opened
	 -608    file is read-only
	 -610    file format error
	 -612    unexpected end of file
	 -630    web files not supported in this version of Stata
	 -631    host not found
	 -632    web file not allowed in this context
	 -633    may not write to web file
	 -660    proxy host not found
	 -661    host or file not found
	 -662    proxy server refused request to send
	 -663    remote connection to proxy failed
	 -665    could not set socket nonblocking
	 -669    invalid URL
	 -670    invalid network port number
	 -671    unknown network protocol
	 -672    server refused to send file
         -673    authorization required by server
	 -674    unexpected response from server
	 -675    server reported server error
	 -676    server refused request to send
	 -677    remote connection failed
	 -678    could not open local network socket
	 -679    unexpected web error
	 -691    I/O error
         -699    insufficient disk space
	-3601    invalid file handle
	-3602    invalid filename
	-3603    invalid file mode
	-3611    too many open files
	-3621    attempt to write read-only file
	-3622    attempt to read write-only file
	-3623    attempt to seek append-only file
	-3698    file seek error
	{hline 61}
{p 8 8 10}
Other codes in the -600 to -699 range are possible.  The codes
in this range correspond to the negative of the corresponding Stata return
code; see {manlink P error}.

{p 4 4 2}
Underscore functions that return a real scalar will return one of these 
codes if there is an error.

{marker underscore}{...}
{p 4 4 2}
If an underscore function does not return a real scalar, then you obtain the
outcome status using {cmd:fstatus()}.  For instance, the read-string functions
return a string scalar or {cmd:J(0,0,"")} on end of file.  The underscore
variants do the same, and they also return {cmd:J(0,0,"")} on error, meaning
error looks like end of file.  You can determine the error code using the
function

	{cmd:fstatus(}{it:fh}{cmd:)}

{p 4 4 2}
{cmd:fstatus()} returns 0 (no previous error) or one of the negative codes
above.  

{p 4 4 2}
{cmd:fstatus()} may be used after any underscore I/O command to obtain 
the current error status.  

{p 4 4 2}
{cmd:fstatus()} may also be used after the nonunderscore I/O commands; 
in that case, {cmd:fstatus()} will return -1 or 0 because all other problems
would have stopped execution.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:fopen(}{it:fn}{cmd:,} {it:mode}{cmd:,} {it:public}{cmd:)}, 
{cmd:_fopen(}{it:fn}{cmd:,} {it:mode}{cmd:,} {it:public}{cmd:)}:
{p_end}
	       {it:fn}:  1 {it:x} 1
	     {it:mode}:  1 {it:x} 1
	   {it:public}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x} 1

    {cmd:fclose(}{it:fh}{cmd:)}:
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_fclose(}{it:fh}{cmd:)}:
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:fget(}{it:fh}{cmd:)},
{cmd:_fget(}{it:fh}{cmd:)},
{cmd:fgetnl(}{it:fh}{cmd:)},
{cmd:_fgetnl(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1  or  0 {it:x} 0 if end of file

{p 4 4 2}
{cmd:fread(}{it:fh}{cmd:,} {it:len}{cmd:)},
{cmd:_fread(}{it:fh}{cmd:,} {it:len}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	      {it:len}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1  or  0 {it:x} 0 if end of file

{p 4 4 2}
{cmd:fput(}{it:fh}{cmd:,} {it:s}{cmd:)},
{cmd:fwrite(}{it:fh}{cmd:,} {it:s}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
		{it:s}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_fput(}{it:fh}{cmd:,} {it:s}{cmd:)},
{cmd:_fwrite(}{it:fh}{cmd:,} {it:s}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
		{it:s}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:fgetmatrix(}{it:fh}{cmd:)},
{cmd:_fgetmatrix(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  {it:r x c}  or  0 {it:x} 0 if end of file


{p 4 4 2}
{cmd:fputmatrix(}{it:fh}{cmd:,} {it:X}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
		{it:X}:  {it:r x c}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_fputmatrix(}{it:fh}{cmd:,} {it:X}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:fstatus(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:ftell(}{it:fh}{cmd:)},
{cmd:_ftell(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:fseek(}{it:fh}{cmd:,} {it:offset}{cmd:,} {it:whence}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	   {it:whence}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_fseek(}{it:fh}{cmd:,} {it:offset}{cmd:,} {it:whence}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	   {it:whence}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:ftruncate(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_ftruncate(}{it:fh}{cmd:)}:
{p_end}
	       {it:fh}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:fopen(}{it:fn}{cmd:,} {it:mode}{cmd:)} aborts with error if 
{it:mode} is invalid or if {it:fn} cannot be opened or if an attempt 
is made to open too many files simultaneously.

{p 4 4 2}
{cmd:_fopen(}{it:fn}{cmd:,} {it:mode}{cmd:)} aborts with error if {it:mode} is
invalid or if an attempt is made to open too many files simultaneously.
{cmd:_fopen()} returns the appropriate negative error code if {it:fn} cannot
be opened.

{p 4 4 2}
All remaining I/O functions -- even functions with leading underscore -- abort
with error if {it:fh} is not a handle to a currently open file.

{p 4 4 2}
Also, the functions that do not begin with an underscore abort with
error when a file was opened read-only and a request requiring write access is
made, when a file is opened write-only and a request requiring read access is
made, etc.  See {it:{help mf_fopen##remarks8:Error codes}} above; all problems
except code -1 (end of file) cause the nonunderscore functions to abort with
error.

{p 4 4 2}
Finally, the following functions will also abort with error for the 
following specific reasons:

{p 4 4 2}
{cmd:fseek(}{it:fh}{cmd:,} {it:offset}{cmd:,} {it:whence}{cmd:)}
and 
{cmd:_fseek(}{it:fh}{cmd:,} {it:offset}{cmd:,} {it:whence}{cmd:)}
abort with error if {it:offset} is outside the range +/-9,007,199,254,740,991
on 64-bit computers or if {it:whence} is not -1, 0, or 1.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ftell.mata, adopath asis:ftell.mata};
other functions are built in.
{p_end}
