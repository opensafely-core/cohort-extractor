{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] printf()" "mansection M-5 printf()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] displayas()" "help mf_displayas"}{...}
{vieweralsosee "[M-5] displayflush()" "help mf_displayflush"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_printf##syntax"}{...}
{viewerjumpto "Description" "mf_printf##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_printf##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_printf##remarks"}{...}
{viewerjumpto "Conformability" "mf_printf##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_printf##diagnostics"}{...}
{viewerjumpto "Source code" "mf_printf##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] printf()} {hline 2}}Format output
{p_end}
{p2col:}({mansection M-5 printf():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:          }
{cmd:printf(}{it:string scalar fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}

{p 8 12 2}
{it:string scalar}
{cmd:sprintf(}{it:string scalar fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}


{p 4 4 2}
where {it:fmt} may contain a mix of text and 
{it:{help format:%fmts}}, such as 

		{cmd:printf("The result is %9.2f, adjusted\n", result)}

		{cmd:printf("%s = %9.0g\n", name, value)}

{p 4 4 2}
There must be a one-to-one correspondence between the {cmd:%}{it:fmts} 
in {it:fmt} and the number of results to be displayed.

{p 4 4 2}
Along with the usual {cmd:%}{it:fmts} that Stata provides (see 
{bf:{help format:[D] format}}), also provided are

		Format                      Meaning
		{hline 56}
		{cmd:%f}                          {cmd:%11.0f}, compressed
		{cmd:%g}                          {cmd:%11.0g}, compressed
		{cmd:%e}                          {cmd:%11.8e}, compressed
		{cmd:%s}                          {cmd:%}{it:#}{cmd:s}, {it:#}=whatever necessary
		{cmd:%us}                         {cmd:%}{it:#}{cmd:us}, {it:#}=whatever necessary
		{cmd:%uds}                        {cmd:%}{it:#}{cmd:uds}, {it:#}=whatever necessary
		{hline 56}
{p 16 16 10}
Compressed means that, after the indicated format is applied, all 
leading and trailing blanks are removed.{break}
C programmers, be warned:  {cmd:%}{cmd:d} is Stata's (old)
calendar date format (equivalent to modern Stata's {cmd:%td} format)
and not an integer format; use {cmd:%f} for
formatting integers.


{p 4 4 2}
The following character sequences are given a special meaning 
when contained within {it:fmt}:

		Character sequence          Meaning
		{hline 42}
		{cmd:%%}                          one % 
		{cmd:\n}                          newline
		{cmd:\r}                          carriage return
		{cmd:\t}                          tab 
		{cmd:\\}                          one \
		{hline 42}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:printf()} displays output at the terminal.

{p 4 4 2}
{cmd:sprintf()} returns a string that can then be displayed 
at the terminal, written to a file, or used in any other way a string 
might be used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 printf()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_printf##remarks1:printf()}
	{help mf_printf##remarks2:sprintf()}
	{help mf_printf##remarks3:The %us and %uds formats}


{marker remarks1}{...}
{title:printf()}

{p 4 4 2}
{cmd:printf()} displays output at the terminal.  A program 
might contain the line 

	{cmd:printf("the result is %f\n", result)}

{p 4 4 2}
and display the output

	{res:the result is 5.213}

{p 4 4 2} 
or it might contain the lines

	{cmd}printf("{c -(}txt{c )-}{c -(}space 13{c )-}{c -(}c |{c )-}      Coef.    Std. Err.\n")
	printf("{c -(}hline 13{c )-}{c -(}c +{c )-}{c -(}hline 24{c )-}\n")
	printf("{c -(}txt{c )-}%12s {c -(}c |{c )-} {c -(}res{c )-}%10.0g  %10.0g\n",
		 				varname[i], coef[i], se[i]){txt}

{p 4 4 2}
and so display the output

	{res}{txt}{space 13}{c |}      Coef.    Std. Err.
	{hline 13}{c +}{hline 24}
	{txt}         mpg {c |} {res} -.0059541    .0005921{txt}

{p 4 4 2}
Do not forget to include {cmd:\n} at the end of lines.  When {cmd:\n} is 
not included, the line continues.  For instance, the code 

	{cmd}printf("{c -(}txt{c )-}{c -(}space 13{c )-}{c -(}c |{c )-}      Coef.    Std. Err.\n")
	printf("{c -(}hline 13{c )-}{c -(}c +{c )-}{c -(}hline 24{c )-}\n")
	printf("{c -(}txt{c )-}%12s {c -(}c |{c )-} {c -(}res{c )-}", varname[i])
	printf("%10.0g", coef[i]) 
	printf(" ")
	printf("%10.0g", se[i]) 
	printf("\n"){txt}

{p 4 4 2}
produces the same output as shown above.

{p 4 4 2}
Although users are unaware of it, Stata buffers output.  This makes Stata
faster.  A side effect of the buffering, however, is that output may not
appear when you want it to appear.  Consider the code fragment

	{cmd}for (n=1; !converged(b, b0); n++) {c -(}
		printf("iteration %f:  diff = %12.0g\n", n, b-b0)
		b0 = b 
		{txt:{it:... new calculation of b ...}}
	{c )-}{txt}

{p 4 4 2}
One of the purposes of the iteration output is to keep the user informed that
the code is indeed working, yet as the above code is written, the user
probably will not see the iteration messages as they occur.  Instead, nothing
will appear for a while, and then, unexpectedly, numerous iteration messages
will appear as Stata, buffers full, decides to send to the terminal the
waiting output.

{marker force}{...}
{p 4 4 2}
To force output to be displayed, use 
{bf:{help mf_displayflush:[M-5] displayflush()}}:

	{cmd}for (n=1; !converged(b, b0); n++) {c -(}
		printf("iteration %f:  diff = %12.0g\n", n, b-b0)
		displayflush()
		b0 = b 
		{txt:{it:... new calculation of b ...}}
	{c )-}{txt}

{p 4 4 2}
It is only in situations like the above that use of {cmd:displayflush()} is
necessary.  In other cases, it is better to let Stata decide when output
buffers should be flushed.  (Ado-file programmers:  you have never had to worry
about this because, at the ado-level, all output is flushed as it is created.
Mata, however, is designed to be fast and so {cmd:printf()} does not force
output to be flushed until it is efficient to do so.)


{marker remarks2}{...}
{title:sprintf()}

{p 4 4 2}
The difference between {cmd:sprintf()} and {cmd:printf()} is that, whereas
{cmd:printf()} sends the resulting string to the terminal, {cmd:sprintf()}
returns it.  Since Mata displays the results of expressions that are not
assigned to variables, {cmd:sprintf()} used by itself also displays output:

	: {cmd:sprintf("the result is %f\n", result)}
	  the result is 5.213{it:0a}

{p 4 4 2}
The outcome is a little different from that produced by {cmd:printf()} because
the output-the-unassigned-expression routine indents results by 2 and
displays all the characters in the string (the {it:0a} at the end is the
{cmd:\n} newline character).  Also, the
output-the-unassigned-expression routine does not honor SMCL, electing instead
to display the codes:

	: {cmd:sprintf("{c -(}txt{c )-}the result is {c -(}res{c )-}%f", result)}
	  {c -(}txt{c )-}the result is {c -(}res{c )-}5.213

{p 4 4 2}
The purpose of {cmd:sprintf()} is to create strings that will then be used
with {cmd:printf()}, with 
{bf:{help mf_display:[M-5] display()}}, with 
{bf:fput()} (see {bf:{help mf_fopen:[M-5] fopen()}}),
or with some other function.

{p 4 4 2}
Pretend that we are creating a dynamically formatted table.  One of the 
columns in the table contains integers, and we want to create a {cmd:%}{it:fmt}
that is exactly the width required.  That is, if the integers to appear 
in the table are 2, 9, and 20, we want to create a {cmd:%2.0f} format for 
the column.  We assume the integers are in the column vector {cmd:dof} 
in what follows:

		{cmd}max = 0
		for (i=1; i<=rows(dof); i++) {c -(} 
			len = strlen(sprintf("%f", dof[i])
			if (len>max) max = len
		{c )-}
		fmt = sprintf("%%%f.0f", max){txt}

{p 4 4 2}
We used {cmd:sprintf()} twice in the above.  We first used {cmd:sprintf()} to
produce the string representation of the integer {cmd:dof[i]}, and we used the
{cmd:%f} format so that the length would be whatever was necessary, and no
more.  We obtained in {cmd:max} the maximum length.  
If {cmd:dof} contained 2, 9, and 20, by the end of our loop, {cmd:max} will
contain 2.  We finally used {cmd:sprintf()} to create the
{cmd:%}{it:#}{cmd:.0f} format that we wanted:  {cmd:%2.0f}.

{p 4 4 2}
The format string "{cmd:%%%f.0f}" in the final {cmd:sprintf()} is a little
difficult to read.  The first two percent signs amount to one real percent
sign, so in the output we now have "{cmd:%}" and we are left with
"{cmd:%f.0f}".  The {cmd:%f} is a format -- it is how we are to format
{cmd:max} -- and so in the output we now have "{cmd:%2}", and we are left with
"{cmd:.0f}".  {cmd:.0f} is just a string, so the final output is
"{cmd:%2.0f}".


{marker remarks3}{...}
{title:The %us and %uds formats}

{p 4 4 2}
The {cmd:%}{it:w}{cmd:us} and {cmd:%}{it:w}{cmd:uds} formats are similar to 
{cmd:%}{it:w}{cmd:s}.  These formats display a string in a right-justified 
field of width {it:w}.  {cmd:%-}{it:w}{cmd:us} and {cmd:%-}{it:w}{cmd:uds} 
display the string in a left-justified field.  {cmd:%~}{it:w}{cmd:us} and 
{cmd:%~}{it:w}{cmd:uds} display the string center-justified.

{p 4 4 2}
The difference between {cmd:%}{it:w}{cmd:s}, {cmd:%}{it:w}{cmd:us}, and 
{cmd:%}{it:w}{cmd:uds} is how the number of padding spaces is calculated.  
{cmd:%}{it:w}{cmd:s} pads the number of spaces to the left of {it:s} to make 
the total number of bytes to be {it:w}.  {cmd:%}{it:w}{cmd:us} pads the number 
of spaces to the left of {it:s} to make the total number of Unicode characters 
to be {it:w}.  {cmd:%}{it:w}{cmd:uds} pads the number of spaces to the left of 
{it:s} to make the total number of 
{mansection U 12.4.2.2DisplayingUnicodecharacters:display columns}
to be {it:w}.

{p 4 4 2}
Note that {it:s} is returned without change if the number of Unicode 
characters is greater than or equal to {it:w} in {cmd:%}{it:w}{cmd:us} or 
if the number of display columns is greater than or equal to {it:w} in 
{cmd:%}{it:w}{cmd:uds}. 


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:printf(}{it:fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}
{p_end}
	      {it:fmt}:  1 {it:x} 1
	       {it:r1}:  1 {it:x} 1
	       {it:r2}:  1 {it:x} 1
	       ...
	       {it:rN}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 8 2}
{cmd:sprintf(}{it:fmt}{cmd:,}
{it:r1}{cmd:,}
{it:r2}{cmd:,}
...{cmd:,}
{it:rN}{cmd:)}
{p_end}
	      {it:fmt}:  1 {it:x} 1
	       {it:r1}:  1 {it:x} 1
	       {it:r2}:  1 {it:x} 1
	       ...
	       {it:rN}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:printf()} and {cmd:sprintf()} abort with error if 
a {cmd:%}{it:fmt} is misspecified, if a numeric {cmd:%}{it:fmt} 
corresponds to a string result or a string {cmd:%}{it:fmt} 
to a numeric result, or there are too few or too many 
{cmd:%}{it:fmts} in {it:fmt} relative 
to the number of {it:results} specified.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
