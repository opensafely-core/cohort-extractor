{* *! version 1.1.1  02mar2015}{...}
    {cmd:filewrite(}{it:f}{cmd:,}{it:s}[{cmd:,}{it:r}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}writes the string specified by {it:s} to the file
specified by {it:f} and returns the number of bytes in the resulting file
{p_end}

{p2col:}If the optional argument {it:r} is specified
as 1, the file specified by {it:f} will be replaced if it exists.
If {it:r} is specified as 2, the file specified by {it:f} will be
appended to if it exists.
Any other values of {it:r} are treated as if {it:r} were not
specified; that is, {it:f} will only be written to if it does
not already exist.
{p_end}

{p2col:}When the file {it:f} is freshly created or is replaced, the
value returned by {cmd:filewrite()} is the number of bytes written to the file,
{cmd:strlen(}{it:s}{cmd:)}.  If {it:r} is specified as 2, and thus
{cmd:filewrite()} is appending to an existing file, the value returned is
the total number of bytes in the resulting file; that is, the value is
the sum of the number of the bytes in the file as it existed before
{cmd:filewrite()} was called and the number of bytes newly written to
it, {cmd:strlen(}{it:s}{cmd:)}.
{p_end}

{p2col:}If the file exists and {it:r} is not specified as 1 or 2,
or an error occurs while writing to the file, then a negative number ({it:#})
is returned, where {cmd:abs(}{it:#}{cmd:)} is a standard Stata error
return code.
{p_end}
{p2col: Domain {it:f}:}filenames{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Domain {it:r}:}integers 1 or 2{p_end}
{p2col: Range:}integers{p_end}
{p2colreset}{...}
