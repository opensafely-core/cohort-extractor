{smcl}
{* *! version 1.1.13  03feb2020}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[P] cscript_log" "help cscript_log"}{...}
{vieweralsosee "[P] rcof" "help rcof"}{...}
{vieweralsosee "[P] savedresults" "help savedresults"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "cscript##syntax"}{...}
{viewerjumpto "Description" "cscript##description"}{...}
{viewerjumpto "Remarks" "cscript##remarks"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] cscript} {hline 2} Begin certification script


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:cscript} [[{cmd:"}]{it:text}[{cmd:"}]]
		[{cmdab:adofile:s} {it:adofile-list}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:cscript} begins a Stata certification script.

{pstd}
It displays a header, performs a {cmd:which} on any listed ado-file (see
{manhelp which R}), and drops all

	data
	frames
	value labels
	macros
	programs
	scalars
	matrices
	constraints
	equations
	previous estimation results

{pstd}
{cmd:cscript} sets {cmd:linesize} to 79; see {help linesize}.  {cmd:cscript}
also sets {cmd:maxiter} to 100; see {helpb set maxiter}.  {cmd:cscript} also
sets {cmd:emptycells} to {cmd:keep}; see
{manhelp set_emptycells R:set emptycells}.  {cmd:cscript} also drops all
frames and restores Stata to its initial state of a single, empty, frame named
{cmd:default}.

{pstd}
The purpose is to reset Stata to default conditions so certification scripts
may be run one after the other without the results of one certification script
affecting the results of another.  {cmd:cscript} sets {cmd:maxiter} to 100 so
test scripts with bad models will not have excessive run times.  Programmers
must specify the {cmd:iterate()} option on commands they want to iterate more
than 100 times; see {helpb maximize:[R] Maximize}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help cscript##remarks1:Introduction}{p_end}
{phang2}{help cscript##remarks2:Other documented and undocumented commands for writing certification scripts}{p_end}
{phang2}{help cscript##remarks3:An example certification script}{p_end}
{phang2}{help cscript##remarks4:Combining certification scripts}{p_end}
{phang2}{help cscript##remarks5:Writing a good certification script}{p_end}


{marker remarks1}{...}
{title:Introduction}

{pstd}
{cmd:cscript} is not documented in the manual because it would not interest
many users.

{pstd}
A certification script is a do-file that tests whether a feature of Stata,
an ado-file, or even a community-contributed command works.

{pstd}
The first line of a certification script do-file should read

{phang2}{cmd:cscript} {it:description_of_test}

{pstd}
For instance,

{phang2}{cmd:cscript sktest}{p_end}
    or
{phang2}{cmd:cscript sktest under usual conditions}

{pstd}
might be the beginning of a do-file that tests {cmd:sktest}.  If
{cmd:sktest} is an ado-file -- as it is -- then a better opening would be

{phang2}{cmd:cscript sktest adofile sktest}{p_end}
    or
{phang2}{cmd:cscript "sktest under usual conditions" adofile sktest}

{pstd}
or, if you prefer, you may perform the {cmd:which} for yourself following
the {cmd:cscript} command:

{phang2}{cmd:cscript sktest}{p_end}
{phang2}{cmd:which sktest}

{pstd}
Which style you use makes no difference, but you should perform the
{cmd:which}.  This way, if you save a log of running the certification script,
you will know which version of {cmd:sktest} you last tested.


{marker remarks2}{...}
{title:Other documented and undocumented commands for writing certification scripts}

{p 4 19 2}{helpb assert} {space 7} verify truth of claim{p_end}
{p 4 19 2}{helpb confirm} {space 6} argument verification{p_end}
{p 4 19 2}{helpb cscript_log} {space 2} control SMCL log files{p_end}
{p 4 19 2}{helpb lrecomp} {space 6} display log relative errors{p_end}
{p 4 19 2}{helpb mkassert} {space 5} generate {cmd:assert}s{p_end}
{p 4 19 2}{helpb rcof} {space 9} verify return code{p_end}
{p 4 19 2}{helpb savedresults} {space 1} manipulate and verify stored results {hi:r()} and {hi:e()}{p_end}
{p 4 19 2}{helpb version} {space 6} run command under version control

{pstd}
Type {cmd:help} followed by the command name for more information.

{pstd}
The {cmd:reldif()} (relative difference) and {cmd:mreldif()} (matrix
relative difference) functions are also helpful in certification scripts; see
{helpb reldif()}.


{marker remarks3}{...}
{title:An example certification script}

{pstd}
At StataCorp, if we have an ado-file called {cmd:mycmd.ado}, we write a
corresponding certification script called {cmd:mycmd.do}.  The script might be

	{hline 3} BEGIN {hline 3} mycmd.do {hline 48}
	{cmd}cscript mycmd adofile mycmd

	use xmpl
	mycmd x1 x2
	assert abs(r(z)-2.5)<=1e-15

	keep if x3==2
	mycmd x1 x2
	local hold = r(z)

	use xmpl, clear
	mycmd x1 x2 if x3==2
	assert r(z) == `hold'

	rcof "noisily mycmd x1" == 102       /* too few variables specified */
	rcof "noisily mycmd x1 x2 x3" == 103 /* too many variables specified */{txt}
	{hline 5} END {hline 3} mycmd.do {hline 48}

{pstd}
A real certification script would be much longer.


{marker remarks4}{...}
{title:Combining certification scripts}

{pstd}
At StataCorp, we then combine all our certification scripts into a super
certification script.  {cmd:mycmd.do} then becomes one element of the super
script:

	{hline 3} BEGIN {hline 3} super.do {hline 3}
	{cmd}do anova
	do assert{txt}
	...
	{cmd}do merge
	do mycmd{txt}
	...
	{hline 5} END {hline 3} super.do {hline 3}

{pstd}
We can run all the certification scripts by typing {cmd:do super}.


{marker remarks5}{...}
{title:Writing a good certification script}

{pstd}
The purpose of a certification script is to

{phang2}1.  test that the command produces the right answers in a few
cases where the solution is known;

{phang2}2.  establish that the command works as it should under extreme
conditions, such as R^2=1 regressions;

{phang2}3.  verify that the command responds to mistakes users are
likely to make in a dignified manner.

{pstd}
Certification scripts are written for two reasons:

{phang2}1.  To establish on day one (the day the command is written) that
the command works.

{phang2}2.  To allow future changes to be made to the command with some
assurance that the changes really are improvements.  (One simply reruns the
certification script.)

{pstd}
A good certification script stops when there is a problem.  This way, typing

	{cmd:. do mycmd}
	[output omitted]
	end of do-file

{pstd}
and seeing it run to completion (that is, seeing Stata respond "end of do-file"
with return code 0) demonstrates that, at least for the recorded problems, the
command works as expected.  You do not want a script where you are required to
review the output to determine whether there are any mistakes.  Thus, a script
that included the lines

{phang2}{cmd:regress mpg weight}{p_end}
{phang2}{cmd:regress mpg weight displ}

{pstd}
would be a poor test of {cmd:regress}.  If the results were wrong, would you
notice?  A better test script would read

{phang2}{cmd:regress mpg weight}{p_end}
{phang2}{cmd:assert abs(_b[weight]- -.0060087) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[_cons]- 39.44028) < 1e-5}

{phang2}{cmd:regress mpg weight displ}{p_end}
{phang2}{cmd:assert abs(_b[weight]- -.0065671) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[displ]- -.0052808) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[_cons]- 40.08452) < 1e-5}

{pstd}
and one that read

{phang2}{cmd:regress mpg weight}{p_end}
{phang2}{cmd:assert abs(_b[weight]- -.0060087) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[_cons]- 39.44028) < 1e-5}{p_end}
{phang2}{cmd:assert abs(_se[weight]-.0005179) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_se[_cons]- 1.614003) < 1e-6}

{phang2}{cmd:regress mpg weight displ}{p_end}
{phang2}{cmd:assert abs(_b[weight]- -.0065671) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[displ]- -.0052808) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_b[_cons]- 40.08452) < 1e-5}{p_end}
{phang2}{cmd:assert abs(_se[weight]-.0011662) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_se[displ]-.0098696) < 1e-7}{p_end}
{phang2}{cmd:assert abs(_se[_cons]- 2.02011) < 1e-6}

{pstd}
would be even better.

{pstd}
To establish that the command responds to mistakes, see
{helpb rcof}.  Scripts should include intentional mistakes and then verify
results are as expected.  For instance,

{phang2}{cmd:discard} {space 15} /* eliminate regression results         */{p_end}
{phang2}{cmd:rcof "regress" == 301} {space 1} /* should be "last estimates not found" */

{pstd}
{cmd:rcof} suppresses all output of the command, so induced errors are
usually coded with a {cmd:noisily} placed in front of the command.

{phang2}{cmd:rcof "noisily regress" == 301}

{pstd}
See {manhelp quietly P}.
{p_end}
