{smcl}
{* *! version 1.1.5  11jun2019}{...}
{vieweralsosee "[M-5] byteorder()" "mansection M-5 byteorder()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] bufio()" "help mf_bufio"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] stataversion()" "help mf_stataversion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_byteorder##syntax"}{...}
{viewerjumpto "Description" "mf_byteorder##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_byteorder##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_byteorder##remarks"}{...}
{viewerjumpto "Conformability" "mf_byteorder##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_byteorder##diagnostics"}{...}
{viewerjumpto "Source code" "mf_byteorder##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] byteorder()} {hline 2}}Byte order used by computer
{p_end}
{p2col:}({mansection M-5 byteorder():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:byteorder()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:byteorder()} returns 1 if the computer is HILO (records most significant
byte first) and returns 2 if LOHI (records least significant byte first).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 byteorder()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Pretend that the values 00 and 01 are recorded at memory positions 58 and 59
and that you know what is recorded there is a 2-byte integer.  How should the
2-byte number be interpreted: as 0001 (meaning 1) or 0100 (meaning 256 in
decimal)?  For different computers, the answer varies.  For HILO computers, the
number is to be interpreted as 0001.  For LOHI computers, the number is
interpreted as 0100.

{pstd}
Regardless, it does not matter because the computer is consistent with itself.
An issue arises, however, when we write binary files that may be read on
computers using a different byte order or when we read files from computers
that used a different byte order.

{pstd}
Stata and Mata automatically handle these problems for you, so you may wish to
stop reading.  {cmd:byteorder()}, however, is the tool on which the solution
is based.  If you intend to write code based on your own binary-file format or
to write code to process the binary files of others, then you may need to use
it.

{pstd}
There are two popular solutions to the byte-order problem:  1) write the
file in a known byte order or 2) write the file by using whichever byte order
is convenient and record the byte order used in the file.  StataCorp tends to
use the second, but others who have worried about this problem have used 
both solutions.

{pstd}
In solution 1, it is usually agreed that the file will be written in HILO
order.  If you are using a HILO computer, you write and read files the
ordinary way, ignoring the problem altogether.  If you are on a LOHI computer,
however, you must reverse the bytes before placing them in the file.  If you
are writing code designed to execute on both kinds of computers, you must
write code for both circumstances, and you must consider the problem when both
reading and writing the files.

{pstd}
In solution 2, files are written LOHI or HILO, depending solely on the
computer being used.  Early in the file, however, the byte order is recorded.
When reading the file, you compare the order in which the file is recorded
with the order of the computer and, if they are different, you reverse bytes.

{pstd}
Mata-buffered I/O utilities will automatically reverse bytes for you.
See {bf:{help mf_bufio:[M-5] bufio()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:byteorder()}:
          {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
