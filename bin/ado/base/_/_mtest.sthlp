{smcl}
{* *! version 1.0.8  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hettest" "help hettest"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{viewerjumpto "Syntax" "_mtest##syntax"}{...}
{viewerjumpto "Description" "_mtest##description"}{...}
{viewerjumpto "Options" "_mtest##options"}{...}
{viewerjumpto "Example" "_mtest##example"}{...}
{viewerjumpto "Acknowledgment" "_mtest##ack"}{...}
{viewerjumpto "References" "_mtest##references"}{...}
{title:Title}

{p 4 20 2}
{hi:[P] _mtest} {hline 2} Adjustment for multiple (simultaneous) testing


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:_mtest} {cmdab:q:uery}

{p 8 15 2}
{cmd:_mtest} {cmdab:s:yntax}{cmd:,}
  {cmdab:m:test}[{cmd:(}{it:name}{cmd:)}]

{p 8 15 2}
{cmd:_mtest} {cmdab:a:djust} {it:matname}{cmd:,}
  {cmdab:m:test}[{cmd:(}{it:name}{cmd:)}]
  [{cmdab:p:index:(}{it:#}{cmd:)}
    {cmd:if(}{it:#}{cmd:)}
    {cmd:replace}
    {cmd:append}]

{p 8 15 2}
{cmd:_mtest} {cmdab:f:ooter} {it:col} {it:type} [{it:symbol}]


{marker description}{...}
{title:Description}

{pstd}When testing multiple hypotheses simultaneously based on a series of
p-values for tests of the individual hypotheses, adjustments should be made
to these p-values to bound the probability of falsely accepting
at least one of these hypotheses (see 
{help _mtest##M1986:Miller [1986]} for details).  {cmd:_mtest}
implements several adjustment methods and is designed to easily
incorporate others.

{pstd}
{cmd:_mtest} has the following subcommands:

{tab}{cmd:_mtest query}
{p 12 12 2}returns in {cmd:r(methods)} the names of the supported methods.
Programmers can use this feature to produce messages (for instance, an error
message) that list the available methods for the {cmd:mtest()} option
that they are
adding to their command.  When new methods are added to {cmd:_mtest}, programs
that use the results of {cmd:_mtest query} will automatically have those new
methods listed.

{tab}{cmd:_mtest syntax}
{p 12 12 2}returns in {cmd:r(method)} the unabbreviated name of the method
implied by {it:name}.  It returns {hi:noadjust} if {cmd:mtest} was specified
without an argument, it returns nothing if {cmd:mtest} was not specified, and
it displays an error message otherwise.

{tab}{cmd:_mtest adjust}
{p 12 12 2}computes p-values that are adjusted for multiple (simultaneous)
testing, based on p-values of n tests (p_1, ..., p_n), stored in a column of
a matrix.  It expects an n x k matrix and returns in {cmd:r(result)} a
column vector of adjusted p-values. Alternatively, it returns the input
matrix with the adjusted p-values replacing the original p-values (option
{cmd:replace}) or appended as an extra column (option {cmd:append}).

{tab}{cmd:_mtest footer}
{p 12 12 2}displays a footer for a table describing how the p-values were
adjusted. {it:col} specifies the column to which the message should be
right aligned.  {it:symbol} is a character used to display what p-values
were adjusted.


{marker options}{...}
{title:Options}

{phang}{cmd:mtest(}{it:name}{cmd:)}
specifies the adjustment method.  The following methods are supported:

{p 10 16 2}{cmdab:b:onferroni} (Bonferroni's method)

{p 14 24 2}p' = min(1, np)

{p 10 16 2}{cmdab:h:olm} (Holm's method)

{p 14 24 2}p' = min(1,n(p)*p), where n(p) is the number of p-values
smaller than p

{p 10 16 2}{cmdab:s:idak} (Sidak's method)

{p 14 24 2}p' = 1 - (1-p)^n

{p 10 16 2}{cmdab:no:adjust}

{p 14 24 2}p' = p; that is, no adjustment is made

{pmore}
Caller commands should typically allow option {cmd:mtest} to be specified
without an argument, implying that multiple testing be performed but that
the p-values not be adjusted for multiple testing.  This option is equivalent
to specifying {cmd:mtest(noadjust)}.  {cmd:_mtest} implements this
behavior as well.

{phang}{cmd:pindex(}{it:#}{cmd:)}
specifies the index of the column in {it:matname} that contains the
p-values.

{phang}{cmd:if(}{it:#}{cmd:)}
specifies the index of the column in {it:matname} that indicates
which rows of {it:matname} are to be included or excluded in the
computations.  Those rows where the value in this column is unequal
to 0 and not missing are included.  The elements in the returned
matrix that correspond to excluded tests are set to missing.  If
{cmd:if} is not specified, all rows are used.

{phang}{cmd:replace}
specifies that {cmd:_mtest} returns in {cmd:r(result)} the matrix
{it:matname} with the column of p-values replaced by the adjusted
p-values.

{phang}{cmd:append}
specifies that {cmd:_mtest} returns in {cmd:r(result)} the matrix
{it:matname} with a column of adjusted p-values added at the end of
the matrix.


{marker example}{...}
{title:Example}

{pstd}
The following code fragment demonstrates how to write a command that
supports multiple testing via {cmd:_mtest}.  This code need not be
modified in any way if new methods for dealing with multiple testing
are added in {cmd:_mtest} ("inheritance").

	{cmd:program define mycmd, rclass}
	{cmd:    syntax} {it:...} {cmd:[, Mtest Mtest2(passthru)} {it:...} {cmd:]}

	{cmd:    _mtest syntax, `mtest2' `mtest'}
	{cmd:    local mtest `r(method)'}

	{cmd:    if "`mtest'" != "" {c -(}}
		{it:...}
	{cmd:        tempname tests}
	{cmd:        mat `tests' = J(n,3,0)}
		{it:...}

{p 16 16 2}fill the matrix tests, with p-value in column 3

	{cmd:        _mtest adjust `tests', pindex(3) replace}
{p 16 16 2}displays multiple tests, with adjusted p-value in column 3

	{cmd:        mat return test r(result)}
	{cmd:    {c )-}}

{p 12 12 2}do any further computations{break}
and display simultaneous test results

	{cmd:end}

{pstd}
Beware that you specify the options {cmd:Mtest} and {cmd:Mtest2(passthru)} in
this order.  The trick to implementing options that take an optional argument
is to specify the argument-accepting option after the nonaccepting option.
If you list them in the other order, the code will not work.

{pstd}
The {cmd:_mtest syntax} subcommand is provided so that the correct syntax
of the {cmd:mtest} or {cmd:mtest2()} option can be verified before indulging
in possibly time-consuming computations for the multiple tests.  If early
syntax checking is not performed, {cmd:_mtest adjust} will still capture the
problem, but only after a delay that may irritate the user.


{marker ack}{...}
{title:Acknowledgment}

{pstd}
{cmd:_mtest} was written by Jeroen Weesie, Department of Sociology, Utrecht
University, The Netherlands.


{marker references}{...}
{title:References}

{phang}Benjamini, Y., and Y. Hochberg.  1995.
  Controlling the false discovery rate: A practical and powerful approach
  to multiple testing.
  {it:Journal of the Royal Statistical Society, Series B} 57: 289-300.

{phang}Holm, S.  1979.
  A simple sequentially rejective multiple test procedure.
  {it:Scandinavian Journal of Statistics} 6: 65-70.

{phang}Jaccard, J., M. Becker, and G. Wood.  1984.
  Pairwise multiple comparisons: A review.
  {it:Psychological Bulletin} 96: 589-596.

{marker M1986}{...}
{phang}Miller, R. G., Jr.  1986.
  {it:Simultaneous Statistical Inference}.  2nd ed.
  New York: Springer.

{phang}Shaffer J. P.  1986.
  Modified sequentially rejective multiple test procedures.
  {it:Journal of the American Statistical Association} 81: 826-831.

{phang}Wright, S. P.  1992.
  Adjusted P-values for simultaneous inference.
  {it:Biometrics} 48: 1005-1013.
{p_end}
