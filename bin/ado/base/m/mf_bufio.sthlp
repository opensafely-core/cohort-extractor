{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-5] bufio()" "mansection M-5 bufio()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fopen()" "help mf_fopen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_bufio##syntax"}{...}
{viewerjumpto "Description" "mf_bufio##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_bufio##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_bufio##remarks"}{...}
{viewerjumpto "Conformability" "mf_bufio##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_bufio##diagnostics"}{...}
{viewerjumpto "Source code" "mf_bufio##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] bufio()} {hline 2}}Buffered (binary) I/O
{p_end}
{p2col:}({mansection M-5 bufio():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:colvector C} {cmd:=} 
{cmd:bufio()}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:bufbyteorder(}{it:C}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:bufbyteorder(}{it:C}{cmd:,}
{it:real scalar byteorder}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:bufmissingvalue(}{it:C}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:bufmissingvalue(}{it:C}{cmd:,}
{it:real scalar version}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:bufput(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}


{p 8 12 2}
{it:scalar}{bind:       }
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:)}

{p 8 12 2}
{it:rowvector}{bind:    }
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:c}{cmd:)}

{p 8 12 2}
{it:matrix}{bind:       }
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:fbufput(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}


{p 8 12 2}
{it:scalar}{bind:       }
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:)}

{p 8 12 2}
{it:rowvector}{bind:    }
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:c}{cmd:)}

{p 8 12 2}
{it:matrix}{bind:       }
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:bufbfmtlen(}{it:string scalar bfmt}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:bufbfmtisnum(}{it:string scalar bfmt}{cmd:)}


{p 4 4 2}
where 

{p 20 24 2}
{it:C}:  {it:colvector} returned by {cmd:bufio()}

{p 20 24 2}
{it:B}:  {it:string scalar} (buffer)
{p_end}
{p 15 24 2}
{it:offset}:  {it:real scalar} (buffer position, starts at 0)

{p 19 24 2}
{it:fh}:  file handle returned by {helpb mf_fopen:fopen()}

{p 16 24 2}
{it:bfmt}:  {it:string scalar} (binary format; see {help mf_bufio##bfmt:below})

{p 20 24 2}
{it:r}:  {it:string scalar}
{p_end}
{p 20 24 2}
{it:c}:  {it:string scalar}
{p_end}
{p 20 24 2}
{it:X}:  value to be written; see {help mf_bufio##remarks:Remarks}


{marker bfmt}{...}
{p 4 4 2}
{it:bfmt} may contain

{col 8}{it:bfmt}{col 25}meaning
{col 8}{hline 68}
{col 8}{...}
{helpb mf_bufio##remarks6:%{c -(}8|4{c )-}z}{...}
{col 25}{...}
8-byte floating point or 4-byte floating point
{...}
{col 8}{...}
{helpb mf_bufio##remarks6:%{c -(}4|2|1{c )-}b[s|u]}{...}
{col 25}{...}
4-, 2-, or 1-byte integer; {help mf_bufio##Stata:Stata}, signed or unsigned
{...}
{col 8}{...}
{helpb mf_bufio##remarks7:%{it:#}s}{...}
{col 25}{...}
text string
{...}
{col 8}{...}
{helpb mf_bufio##remarks7:%{it:#}S}{...}
{col 25}{...}
binary string
{col 8}{hline 68}


{marker description}{...}
{title:Description}

{pstd}
These functions manipulate buffers (string scalars) containing binary data and,
optionally, perform I/O.

{pstd}
{cmd:bufio()} returns a control vector, {it:C}, that you pass to the other
buffer functions.  {it:C} specifies the byte order of the buffer and specifies
how missing values are to be encoded.  Despite its name, {cmd:bufio()} opens
no files and performs no I/O.  {cmd:bufio()} merely returns a vector of
default values for use with the remaining buffer functions.

{pstd}
{cmd:bufbyteorder()} and {cmd:bufmissingvalue()} 
allow changing the defaults in {it:C}.

{pstd}
{cmd:bufput()} and {cmd:bufget()} copy elements into and out of buffers.  No
I/O is performed.  Buffers can then be written by using {cmd:fwrite()} and
read by using {cmd:fread()}; see {bf:{help mf_fopen:[M-5] fopen()}}.

{pstd} 
{cmd:fbufput()} and {cmd:fbufget()} do the same, and they perform the
corresponding I/O by using {cmd:fwrite()} or {cmd:fread()}.

{pstd}
{cmd:bufbfmtlen(}{it:bfmt}{cmd:)} and {cmd:bufbfmtisnum(}{it:bfmt}{cmd:)} are
utility routines for processing {it:bfmts}; they are rarely used.
{cmd:bufbfmtlen(}{it:bfmt}{cmd:)} returns the implied length, in bytes, of the
specified {it:bfmt}, and {cmd:bufbfmtisnum(}{it:bfmt}{cmd:)} returns 1 if the
{it:bfmt} is numeric, 0 if string.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 bufio()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you wish simply to read and write matrices, etc., see {cmd:fgetmatrix()}
and {cmd:fputmatrix()} and the other functions in
{bf:{help mf_fopen:[M-5] fopen()}}.

{pstd}
The functions documented here are of interest if

{p 8 12 2}
1.  you wish to create your own binary-data format because you are 
    writing routines in low-level languages such as FORTRAN or C
    and need to transfer data between your new routines and Stata, or 

{p 8 12 2}
2.  you wish to write a program to read and write the binary format of another
    software package.

{pstd}
These are advanced and tedious programming projects.

{pstd} 
Remarks are presented under the following headings:

	{help mf_bufio##remarks1:Basics}
	{help mf_bufio##remarks2:Argument C}
	{help mf_bufio##remarks3:Arguments B and offset}
	{help mf_bufio##remarks4:Argument fh}
	{help mf_bufio##remarks5:Argument bfmt}
	{help mf_bufio##remarks6:bfmts for numeric data}
	{help mf_bufio##remarks7:bfmts for string data}
	{help mf_bufio##remarks8:Argument X}
	{help mf_bufio##remarks9:Arguments r and c}
	{help mf_bufio##remarks10:Advanced issues}


{marker remarks1}{...}
{title:Basics}

{pstd}
Let's assume that you wish to write a matrix to disk so you can move it back 
and forth from FORTRAN.  You settle on a file format in which the 
number of rows and number of columns are first written as 4-byte integers, 
and then the values of the matrix are written as 8-byte doubles, by row:

	{c TLC}{hline 8}{c TT}{hline 8}{c TT}{hline 16}{c TT}{hline 16}{c TT}{hline 2} 
	{c |} # rows {c |} # cols {c |}         X[1,1] {c |}         X[1,2] {c |}  ... 
	{c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 16}{c BT}{hline 16}{c BT}{hline 2} 
	  4 bytes  4 bytes      8 bytes          8 bytes      

{pstd} 
One solution to writing matrices in such a format is

	{cmd:fh = fopen("}{it:filename}{cmd:", "w")}
	{cmd:C  = bufio()}
	{cmd:fbufput(C, fh, "%4b", rows(X))}
	{cmd:fbufput(C, fh, "%4b", cols(X))}
	{cmd:fbufput(C, fh, "%8z", X)}
	{cmd:fclose(fh)}

{pstd}
The code to read the matrix back is

	{cmd:fh   = fopen("}{it:filename}{cmd:", "r")}
	{cmd:C    = bufio()}
	{cmd:rows = fbufget(C, fh, "%4b")}
	{cmd:cols = fbufget(C, fh, "%4b")}
	{cmd:X    = fbufget(C, fh, "%8z", rows, cols)}
	{cmd:fclose(fh)}

{pstd}
Another solution, which would be slightly more efficient, is

	{cmd:fh = fopen("}{it:filename}{cmd:", "w")}
	{cmd:C   = bufio()}
	{cmd:buf = 8*char(0)}
	{cmd:bufput(C, buf, 0, "%4b", rows(X))}
	{cmd:bufput(C, buf, 4, "%4b", cols(X))}
	{cmd:fwrite(C, buf)}
	{cmd:fbufput(C, fh, "%8z", X)}
	{cmd:fclose(fh)}

{pstd}
and

	{cmd:fh   = fopen("}{it:filename}{cmd:", "r")}
	{cmd:C    = bufio()}
	{cmd:buf  = fread(fh, 8)}
	{cmd:rows = bufget(C, buf, 0, "%4b")}
	{cmd:cols = bufget(C, buf, 4, "%4b")}
	{cmd:X    = fbufget(C, fh, "%8z", rows, cols)}
	{cmd:fclose(fh)}

{pstd}
What makes the above approach more efficient is that, rather than writing 
4 bytes (the number of rows), and 4 bytes again (the number of columns), we
created one 8-byte buffer and put the two 4-byte fields in it, and then we
wrote all 8 bytes at once.  We did the reverse when we read back the data:  we
read all 8 bytes and then broke out the fields.  The benefit is minuscule here
but, in general, writing longer buffers results in faster I/O.

{pstd}
In all the above examples, we wrote and read the entire matrix with 
one function call, 

	{cmd:fbufput(C, fh, "%8z", X)}

{pstd}
and 

	{cmd:X    = fbufget(C, fh, "%8z", rows, cols)}

{pstd}
Perhaps you would have preferred our having coded

	{cmd}for (i=1; i<=rows(X); i++) {
		for (j=1; j<=cols(X); j++) {
			fbufput(C, fh, "%8z", X[i,j])
		}
	}{txt}

{pstd}
and perhaps you would have preferred our having coded something similar to
read back the matrix.  Had we done so, the results would have been the same.

{pstd}
If you are familiar with FORTRAN, you know that it records matrices in 
column-dominant order, rather than the row-dominant order used by Mata.
It would be a little easier to code the FORTRAN side of things if we 
changed our file-format design to write columns first:

	{c TLC}{hline 8}{c TT}{hline 8}{c TT}{hline 16}{c TT}{hline 16}{c TT}{hline 2} 
	{c |} # rows {c |} # cols {c |}         X[1,1] {c |}         X[2,1] {c |}  ... 
	{c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 16}{c BT}{hline 16}{c BT}{hline 2} 
	  4 bytes  4 bytes      8 bytes          8 bytes      

{pstd}
One way we could do that would be to write the loops ourselves:

	{cmd:fh = fopen("}{it:filename}{cmd:", "w")}
	{cmd:C  = bufio()}
	{cmd:fbufput(C, fh, "%4b", rows(X))}
	{cmd:fbufput(C, fh, "%4b", cols(X))}
	{cmd}for (j=1; j<=cols(X); i++) {
		for (i=1; i<=rows(X); j++) {
			fbufput(C, fh, "%8z", X[i,j])
		}
	}{txt}

{pstd} 
and

	{cmd:fh   = fopen("}{it:filename}{cmd:", "r")}
	{cmd:C    = bufio()}
	{cmd:rows = fbufget(C, fh, "%4b")}
	{cmd:cols = fbufget(C, fh, "%4b")}
	{cmd:X    = J(rows, cols, .)}
	{cmd}for (j=1; j<=cols(X); i++) {
		for (i=1; i<=rows(X); j++) {
			X[i,j] = fbufget(C, fh, "%8z")
		}
	}{txt}

{pstd}
We could do that, but there are more efficient and easier ways to 
proceed.  For instance, we could simply transpose the matrix before writing 
and after reading, and if we do that transposition in place, our code will
use no extra memory:

	{cmd:fh = fopen("}{it:filename}{cmd:", "w")}
	{cmd:C  = bufio()}
	{cmd:fbufput(C, fh, "%4b", rows(X))}
	{cmd:fbufput(C, fh, "%4b", cols(X))}
	{cmd:_transpose(X)}
	{cmd:fbufput(C, fh, "%8z", X)}
	{cmd:_transpose(X)}
	{cmd:fclose(fh)}

{pstd}
The code to read the matrices back is

	{cmd:fh   = fopen("}{it:filename}{cmd:", "r")}
	{cmd:C    = bufio()}
	{cmd:rows = bufget(C, fh, "%4b")}
	{cmd:cols = bufget(C, fh, "%4b")}
	{cmd:X    = fbufget(C, fh, "%8z", cols, rows)}
	{cmd:_transpose(X)}
	{cmd:fclose(fh)}


{marker remarks2}{...}
{title:Argument C}

{pstd}
Argument {it:C} in  

{p 8 8 2}
{cmd:bufput(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)}, 

{p 8 8 2}
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)},

{p 8 8 2}
{cmd:fbufput(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)},
and

{p 8 8 2}
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)}

{pstd}
specifies the control vector.  You obtain {it:C} by coding

	{cmd:C = bufio()}

{pstd}
{cmd:bufio()} returns {it:C}, which is nothing more than a vector filled
in with default values.
The other buffer routines know how to 
interpret the vector.  The vector contains two pieces of information:

{p 8 12 2}
1.
The byte order to be used.

{p 8 12 2}
2.  
The missing-value coding scheme to be used.

{pstd}
Some computer hardware writes numbers left to right (for example, Sun) and other
computer hardware writes numbers right to left (for example, Intel); see
{bf:{help mf_byteorder:[M-5] byteorder()}}.  If you are going
to write binary files, and if you want your files to be readable on 
all computers, you must write code to deal with this issue.

{pstd}
Many programmers ignore the issue because the programs they write are intended
for one computer or on computers like the one they use.  If that is the case,
you can ignore the issue, too.  The default byte order filled in by
{cmd:bufio()} is the byte order of the computer you are using.

{pstd}
If you intend to read and write files across different computers, however,
you will need to concern yourself with byte order, and how you do that is
described in {it:{help mf_bufio##remarks10:Advanced issues}}, below.

{pstd}
The other issue you may need to consider is missing values.  If you are
writing a binary format that is intended to be used outside Stata, it is best
if the values you write simply do not include missing values.  Not all
packages have them, and the packages that do don't agree on how they are
encoded.  In such cases, if the data you are writing include missing values,
change the values to another value such as -1, 99, 999, or -9999.

{pstd}
If, however, you are writing binary files in Stata to be read back in Stata,
you can allow Stata's missing values {cmd:.}, {cmd:.a}, {cmd:.b}, ...,
{cmd:.z}.  No special action is required.  The missing-value scheme in {it:C}
specifies how those missing values are encoded, and there is only one way
right now, so there is in fact no issue at all.  {it:C} includes the extra
information in case Stata ever changes the way it encodes missing values so
that you will have a way to read and write old-format files.  How this process
works is described in {it:{help mf_bufio##remarks10:Advanced issues}}.


{marker remarks3}{...}
{title:Arguments B and offset}

{pstd}
Functions

{p 8 8 2}
{cmd:bufput(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)} and 

{p 8 8 2}
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)}

{pstd} 
do not perform I/O; they copy values into and out of the buffer.
{it:B} specifies the buffer, and {it:offset} specifies the position within 
it.

{pstd} 
{it:B} is a string scalar.

{pstd}
{it:offset} is an integer scalar specifying the position within {it:B}.
Offset 0 specifies the first byte of {it:B}.

{pstd}
For {cmd:bufput()}, {it:B} must already exist and be long enough to receive
the result, and it is usual to code something like

	{cmd}B = (4 + 4 + rows(X)*cols(X)*8) * char(0)
	bufput(C, B, 0, "%4b", rows(X))
	bufput(C, B, 4, "%4b", cols(X))
	bufput(C, B, 8, "%8z", X){txt}


{marker remarks4}{...}
{title:Argument fh}

{pstd}
Argument {it:fh} in 

{p 8 8 2}
{cmd:fbufput(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)}
and

{p 8 8 2}
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)}

{pstd}
plays the role of arguments {it:B} and {it:offset} in {cmd:bufput()} and
{cmd:bufget()}.  Rather than copy into or out of a buffer, data are written
to, or read from, file {it:fh}.  {it:fh} is obtained from {cmd:fopen()}; see
{bf:{help mf_fopen:[M-5] fopen()}}.


{marker remarks5}{...}
{title:Argument bfmt}

{pstd}
Argument {it:bfmt} in 

{p 8 8 2}
{cmd:bufput(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)}, 

{p 8 8 2}
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)},

{p 8 8 2}
{cmd:fbufput(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)},
and

{p 8 8 2}
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)}

{pstd}
specifies how the elements are to be written or read.


{marker remarks6}{...}
{title:bfmts for numeric data}

{pstd}
The numeric {it:bfmts} are

	{it:bfmt}{col 20}Interpretation
	{hline 35}
	{cmd:%8z}{col 20}8-byte floating point
	{cmd:%4z}{col 20}4-byte floating point

	{cmd:%4bu}{col 20}4-byte unsigned integer
	{cmd:%4bs}{col 20}4-byte signed integer
	{cmd:%4b}{col 20}4-byte Stata integer

	{cmd:%2bu}{col 20}2-byte unsigned integer
	{cmd:%2bs}{col 20}2-byte signed integer
	{cmd:%2b}{col 20}2-byte Stata integer

	{cmd:%1bu}{col 20}1-byte unsigned integer
	{cmd:%1bs}{col 20}1-byte signed integer
	{cmd:%1b}{col 20}1-byte Stata integer
	{hline 35}

{marker Stata}{...}
{pstd}
A Stata integer is the same as a signed integer, except that the 
largest 27 values are given the interpretation {cmd:.}, {cmd:.a}, 
{cmd:.b}, ..., {cmd:.z}.


{marker remarks7}{...}
{title:bfmts for string data}

{pstd}
The string {it:bfmts} are

	{it:bfmt}{col 20}Interpretation
	{hline 35}
	{cmd:%}{it:#}{cmd:s}{col 20}text string
	{cmd:%}{it:#}{cmd:S}{col 20}binary string
	{hline 35}

{pstd}
where {it:#} represents the length of the string field.  
Examples include {cmd:%8s} and {cmd:%639876S}.

{pstd}
When writing, it does not matter whether you use 
{cmd:%}{it:#}{cmd:s} or 
{cmd:%}{it:#}{cmd:S}, the same actions are taken:

{p 8 12 2}
1.
If the string being written is shorter than {it:#}, the field is 
padded with {cmd:char(0)}.

{p 8 12 2}
2.
If the string being written is longer than {it:#}, only the first 
{it:#} bytes of the string are written.

{pstd}
When reading, the distinction between 
{cmd:%}{it:#}{cmd:s} 
and 
{cmd:%}{it:#}{cmd:S} is important:

{p 8 12 2}
1.  When reading with
{cmd:%}{it:#}{cmd:s},
if {cmd:char(0)} appears within the first {it:#} bytes, the returned 
result is truncated at that point.

{p 8 12 2}
2.  When reading with
{cmd:%}{it:#}{cmd:S},
a full {it:#} bytes are returned in all cases.


{marker remarks8}{...}
{title:Argument X}

{pstd}
Argument {it:X} in 

{p 8 8 2}
{cmd:bufput(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)}
and

{p 8 8 2}
{cmd:fbufput(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,}
	{it:X}{cmd:)}

{pstd}
specifies the value to be written.  {it:X} may be real or string and may be a
scalar, vector, or matrix.  If {it:X} is a vector, the elements are written
one after the other.  If {it:X} is a matrix, the elements of the first row are
written one after the other, followed by the elements of the second row, and
so on.

{pstd}
In 

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	...{cmd:)}
and

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,}
	...{cmd:)}

{pstd}
{it:X} is returned.


{marker remarks9}{...}
{title:Arguments r and c}

{pstd}
Arguments {it:r} and {it:c} are optional in the following:

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:)}, 

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:c}{cmd:)}, 

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:r}{cmd:,} 
	{it:c}{cmd:)}, 

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:)}, 

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:c}{cmd:)}, 
and

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:r}{cmd:,} 
	{it:c}{cmd:)}.

{pstd}
If {it:r} is not specified, results are as if {it:r} = 1.

{pstd}
If {it:c} is not specified, results are as if {it:c} = 1.

{pstd}
Thus

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:)}, 
and

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:)}

{pstd}
read one element, and return it, 
whereas 

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:c}{cmd:)}, 
and

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:c}{cmd:)}

{pstd}
read {it:c} elements and return them in a column vector, and 

{p 8 8 2}
{it:X} = 
{cmd:bufget(}{it:C}{cmd:,}
	{it:B}{cmd:,}
	{it:offset}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:r}{cmd:,} 
	{it:c}{cmd:)}
and

{p 8 8 2}
{it:X} = 
{cmd:fbufget(}{it:C}{cmd:,}
	{it:fh}{cmd:,}
	{it:bfmt}{cmd:,} 
	{it:r}{cmd:,} 
	{it:c}{cmd:)}

{pstd}
read {it:r}*{it:c} elements and return them in an {it:r} {it:x} {it:c} matrix.


{marker remarks10}{...}
{title:Advanced issues}

{pstd}
A properly designed binary-file format includes a signature line 
first thing in the file:

	{cmd:fh = fopen(filename, "w")}
        {cmd:fwrite(fh, "MyFormat For Mats v. 1.0")}
                 /* ----+----1----+----2---- */

{pstd}
and 

	{cmd:fh = fopen(filename, "r")}
	{cmd}if (fread(fh, 24) != "MyFormat For Mats v. 1.0") {
		errprintf("%s not My-Format file\n", filename)
		exit(610)
	}{txt}

{pstd}
If you are concerned with byte order and mapping of missing values, you should
write the byte order and missing-value mapping in the file, write in natural
byte order, and be prepared to read back in either byte order.

{pstd}
The code for writing is

	{cmd}fh = fopen(filename, "w")
        fwrite(fh, "MyFormat For Mats v. 1.0")

	C = bufio()
	fbufput(C, fh, "%1bu", bufbyteorder(C))
	fbufput(C, fh, "%2bu", bufmissingvalue(C)){txt}

{pstd}
and the corresponding code for reading the file is

	{cmd:fh = fopen(filename, "r")}
	{cmd}if (fread(fh, 24) != "MyFormat For Mats v. 1.0") {
		errprintf("%s not My-Format file\n", filename)
		exit(610)
	}

	C = bufio()
	bufbyteorder(C, fbufget(C, "%1bu"))
	bufmissingvalue(C, fbufget(C, "%2bu")){txt}

{pstd}
All we write in the file before recording the byte order are strings and
bytes.  This way, when we read the file later, we can set the byte order
before reading any 2-, 4-, or 8-byte fields.

{pstd}
{cmd:bufbyteorder(}{it:C}{cmd:)} -- {cmd:bufbyteorder()} with one argument -- 
returns the byte-order encoding recorded in {it:C}.  It returns 1 (meaning
HILO) or 2 (meaning LOHI).

{pstd}
{cmd:bufbyteorder(}{it:C}{cmd:,} {it:value}{cmd:)} -- 
{cmd:bufbyteorder()} with two arguments -- 
resets the byte order recorded in {it:C}.  Once reset, all buffer
functions will automatically reverse bytes if necessary.

{pstd}
{cmd:bufmissingvalue()} works the same way.  With one argument, it 
returns a code for the encoding scheme recorded in {it:C} (said code being the
Stata release number multiplied by 100).  With two arguments, it resets the
code.  Once the code is reset, all buffer routines used will automatically
take the appropriate action.


{marker conformability}{...}
{title:Conformability}

    {cmd:bufio()}:
	   {it:result}:  {it:colvector}

    {cmd:bufbyteorder(}{it:C}{cmd:)}:
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	   {it:result}:  1 {it:x} 1{col 32}containing 1 (HILO) or 2 (LOHI)

    {cmd:bufbyteorder(}{it:C}{cmd:,} {it:byteorder}{cmd:)}:
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	{it:byteorder}:  1 {it:x} 1{col 32}containing 1 (HILO) or 2 (LOHI)
	   {it:result}:  {it:void}

    {cmd:bufmissingvalue(}{it:C}{cmd:)}:
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	   {it:result}:  1 {it:x} 1 

    {cmd:bufmissingvalue(}{it:C}{cmd:,} {it:version}{cmd:)}:
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	  {it:version}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:bufput(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
		{it:B}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:X}:  {it:r x c}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
		{it:B}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
		{it:B}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:r}:  1 {it:x} 1
	   {it:result}:  1 {it:x c}

{p 4 4 2}
{cmd:bufget(}{it:C}{cmd:,}
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
		{it:B}:  1 {it:x} 1
	   {it:offset}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:r}:  1 {it:x} 1
		{it:c}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:fbufput(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	       {it:fh}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:X}:  {it:r x c}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	       {it:fh}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	       {it:fh}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:r}:  1 {it:x} 1
	   {it:result}:  1 {it:x c}

{p 4 4 2}
{cmd:fbufget(}{it:C}{cmd:,}
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}:
{p_end}
		{it:C}:  {it:colvector}{col 32}made by {cmd:bufio()}
	       {it:fh}:  1 {it:x} 1
	     {it:bfmt}:  1 {it:x} 1
		{it:r}:  1 {it:x} 1
		{it:c}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:bufbfmtlen(}{it:bfmt}{cmd:)}:
	     {it:bfmt}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:bufbfmtisnum(}{it:bfmt}{cmd:)}:
	     {it:bfmt}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:bufio()} cannot fail.

{pstd}
{cmd:bufbyteorder(}{it:C}{cmd:)} cannot fail.
{cmd:bufbyteorder(}{it:C}{cmd:,} {it:byteorder}{cmd:)} 
aborts with error if {it:byteorder} is not 1 or 2.

{pstd}
{cmd:bufmissingvalue(}{it:C}{cmd:)} cannot fail.
{cmd:bufmissingvalue(}{it:C}{cmd:,} {it:version}{cmd:)} 
aborts with error if {it:version} < 100 or 
{it:version} > {bf:{help mf_stataversion:stataversion()}}.

{pstd}
{cmd:bufput(}{it:C}{cmd:,} 
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}
aborts with error 
if {it:B} is too short to receive the result, 
{it:offset} is out of range, 
{it:bfmt} is invalid, 
or 
{it:bfmt} is a string format and {it:X} is numeric or vice versa.
Putting a void matrix results in 0 bytes being inserted into the buffer
and is not an error.

{pstd}
{cmd:bufget(}{it:C}{cmd:,} 
{it:B}{cmd:,}
{it:offset}{cmd:,}
{it:bfmt}{cmd:,}
...{cmd:)}
aborts with error 
if {it:B} is too short, 
{it:offset} is out of range, 
or
{it:bfmt} is invalid.
Reading zero rows or columns results in a void returned result
and is not an error.

{pstd}
{cmd:fbufput(}{it:C}{cmd:,} 
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
{it:X}{cmd:)}
aborts with error 
if {it:fh} is invalid, 
{it:bfmt} is invalid, 
or 
{it:bfmt} is a string format and {it:X} is numeric or vice versa.
Putting a void matrix results in 0 bytes being written and is not an error.
I/O errors are possible; use {helpb mf_fstatus:fstatus()} to detect them.

{pstd}
{cmd:fbufget(}{it:C}{cmd:,} 
{it:fh}{cmd:,}
{it:bfmt}{cmd:,}
...{cmd:)}
aborts with error 
if {it:fh} is invalid
or
{it:bfmt} is invalid.
Reading zero rows or columns results in a void returned result and is not an
error.  End-of-file and I/O errors are possible; use
{helpb mf_fstatus:fstatus()} to detect them.

{pstd}
{cmd:bufbfmtlen(}{it:bfmt}{cmd:)}
and 
{cmd:bufbfmtisnum(}{it:bfmt}{cmd:)}
abort with error if {it:bfmt} is invalid.


{marker source}{...}
{title:Source code}

{pstd}
{view bufio.mata, adopath asis:bufio.mata}, 
{view bufbyteorder.mata, adopath asis:bufbyteorder.mata}, 
{view bufmissingvalue.mata, adopath asis:bufmissingvalue.mata},
{view fbufput.mata, adopath asis:fbufput.mata},
{view fbufget.mata, adopath asis:fbufget.mata};
other functions are built in.
{p_end}
