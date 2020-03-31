{* *! version 1.1.2  25mar2015}{...}
    {cmd:filereaderror(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:0} or positive integer, said value having the
           interpretation of a return code{p_end}

{p2col:}It is used like this

{p 24 26 2}{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:) if fileexists(}{it:filename}{cmd:)}{p_end}
{p 24 26 2}{cmd:. assert filereaderror(}{it:s}{cmd:)==0}

{p2col:}or this

{p 24 26 2}{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:) if fileexists(}{it:filename}{cmd:)}{p_end}
{p 24 26 2}{cmd:. generate} {it:rc} {cmd:= filereaderror(}{it:s}{cmd:)}

{p2col:}That is, {opt filereaderror(s)} is used on the result
	  returned by {opt fileread(filename)} to determine whether an I/O
	  error occurred.

{p2col:}In the example, we only {cmd:fileread()} files that
	  {cmd:fileexists()}.  That is not required.  If the file does not
	  exist, that will be detected by {cmd:filereaderror()} as an error.
	  The way we showed the example, we did not want to read missing files
	  as errors.  If we wanted to treat missing files as errors, we would
	  have coded

{p 24 26 2}{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}{p_end}
{p 24 26 2}{cmd:. assert filereaderror(}{it:s}{cmd:)==0}

{p2col:}or

{p 24 26 2}{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}{p_end}
{p 24 26 2}{cmd:. generate} {it:rc} {cmd:= filereaderror(}{it:s}{cmd:)}{p_end}
{p2col: Domain:}strings{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
