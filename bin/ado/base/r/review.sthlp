{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[R] #review" "mansection R review"}{...}
{viewerjumpto "Syntax" "review##syntax"}{...}
{viewerjumpto "Description" "review##description"}{...}
{viewerjumpto "Remarks" "review##remarks"}{...}
{viewerjumpto "Examples" "review##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] #review} {hline 2}}Review previous commands{p_end}
{p2col:}({mansection R #review:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{opt #r:eview} [{it:#1} [{it:#2}]]


{marker description}{...}
{title:Description}

{pstd}
The {cmd:#review} command displays the last few lines typed at the terminal.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:#review} (pronounced {it:pound-review} is a Stata preprocessor command.
{cmd:#}{it:command}s do not generate a return code or generate ordinary Stata
errors.  The only error message associated with {cmd:#}{it:command}s is
"unrecognized #command".

{pstd}
The {cmd:#review} command displays the last few lines typed at the terminal.
If no arguments follow {cmd:#review}, the last five lines typed at the terminal
are displayed.  The first argument specifies the number of lines to be
reviewed, so {cmd:#review 10} displays the last 10 lines typed.  The second
argument specifies the number of lines to be displayed, so {cmd:#review 10 5}
displays five lines, starting at the 10th previous line.

{pstd}
Stata reserves a buffer for {cmd:#review} lines and stores as many previous
lines in the buffer as will fit, rolling out the oldest line to make room for
the newest.  Requests to {cmd:#review} lines no longer stored will be ignored.
Only lines typed at the terminal are placed in the {cmd:#review} buffer.  See 
{findalias fredit}.


{marker examples}{...}
{title:Examples}

{pstd}Display last five lines typed at the terminal{p_end}
{phang2}{cmd:. #review}{p_end}

{pstd}Same as above command{p_end}
{phang2}{cmd:. #r}{p_end}

{pstd}Display last 10 lines typed at the terminal{p_end}
{phang2}{cmd:. #review 10}{p_end}

{pstd}Display last 100 lines typed at the terminal{p_end}
{phang2}{cmd:. #review 100}{p_end}

{pstd}Display last 10 lines typed at the terminal beginning with the 20th
previous line{p_end}
{phang2}{cmd:. #review 20 10}{p_end}
