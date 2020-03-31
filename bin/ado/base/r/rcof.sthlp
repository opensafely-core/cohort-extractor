{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{viewerjumpto "Syntax" "rcof##syntax"}{...}
{viewerjumpto "Description" "rcof##description"}{...}
{viewerjumpto "Remarks" "rcof##remarks"}{...}
{viewerjumpto "Examples" "rcof##examples"}{...}
{title:Title}

{p 4 18 2}
{hi:[P] rcof} {hline 2} Verify return code


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:rcof} [{cmd:"}]{it:stata_cmd}[{cmd:"}] {it:rest_of_expression}


{pstd}
This command is intended for authors of certification scripts -- do-files
used to test that commands work properly; see {manhelp cscript P}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:rcof} executes {it:stata_cmd} and then verifies that the return code
is as indicated.


{marker remarks}{...}
{title:Remarks}

{pstd}
In a certification script, one might purposely issue a {it:stata_cmd} that
should produce an error and then verify that the expected error is produced.
If the assertion is true, the script continues.  If the assertion is false,
the script stops.


{marker examples}{...}
{title:Examples}

{phang2}{cmd:. discard} {space 2} /* thus removing estimation results */{p_end}
{phang2}{cmd:. rcof "regress" == 301}

{phang2}{cmd:. rcof "regress mpg weight badvar" == 111}

{pstd}
If the return code from the command is 111, that is, if, had you typed just
the command, you would have seen,

{phang2}{cmd:. regress mpg weight badvar}{p_end}
{phang2}{err:badvar not found}{p_end}
{phang2}{search r(111):r(111);}

{pstd}
then the certification script will continue.  Output from {it:stata_cmd} is
suppressed.  If you want to see the output (which would typically be an error
message), include {cmd:noisily} (see {manhelp quietly P}) in the
{it:stata_cmd}:

{phang2}{cmd:. rcof "noisily regress mpg weight badvar" == 111}

{pstd}
In that case, you will see

{phang2}{cmd:. rcof "noisily regress mpg weight badvar" == 111}{p_end}
{phang2}{err:badvar not found}

{pstd}
but the certification script will not stop.  On the other hand, here is what
happens when the return code is not as you assert:

{phang2}{cmd:. rcof "regress mpg weight badvar" == 198}

	{err}rcof:  _rc  == 198 *NOT TRUE* from
	       regress mpg weight badvar
	       _rc == 111{txt}
	{search r(9):r(9);}

{pstd}
You may omit the double quotes when {it:stata_cmd} does not contain the
characters {cmd:=}, {cmd:<}, {cmd:>}, {cmd:~}, and {cmd:!}.

{phang2}{cmd:. rcof noisily regress mpg weight badvar == 111}

    would work but

{phang2}{cmd:. rcof gen mpg = 3 == 110}

{pstd}
would not have the intended result.  In this case, you must code

{phang2}{cmd:. rcof "gen mpg = 3" == 110}

{pstd}
Omitting the double quotes is not encouraged.
{p_end}
