{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{viewerjumpto "Syntax" "lrecomp##syntax"}{...}
{viewerjumpto "Description" "lrecomp##description"}{...}
{viewerjumpto "Remarks" "lrecomp##remarks"}{...}
{viewerjumpto "Example" "lrecomp##example"}{...}
{title:Title}

{p 4 21 2}
{hi:[P] lrecomp} {hline 2} Display log relative errors


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:lrecomp} {it:exp} {it:exp} [{it:exp} {it:exp} [{cmd:()}]
		[{it:exp} {it:exp} [{cmd:()}] [{it:...}]]]


{marker description}{...}
{title:Description}

{pstd}
{cmd:lrecomp} is used to make tables of the number of correctly estimated
digits (LREs) when comparing calculated results to known-to-be-correct
results.

{pstd}
In each pair of expressions, the first is the calculated result and the
second the known-to-be-correct result.

{pstd}
You may also include {cmd:()} to specify that the minimum LRE to that point
be reported.  Multiple {cmd:()}s may be coded, and the minimum from the
previous {cmd:()} to the current {cmd:()} is reported.


{marker remarks}{...}
{title:Remarks}

{pstd}
In reporting comparisons of calculated results with true results, it is
popular to report the LRE -- the log relative error.  Let c represent a
calculated result and t the known-to-be-correct answer.  The formal definition
of this comparison is

	LRE  =   -log10(|c-t|)        if t == 0
	     =   -log10(|(c-t)/t|)    otherwise

{pstd}
The result of this calculation is then called "Digits of Accuracy" or, more
precisely, "Decimal Digits of Accuracy".

{pstd}
Double-precision calculations carry roughly 16.5 digits of accuracy so, in
theory, one should report min(16.5, LRE).  In practice, it has become
common to report min(15, LRE) because many certified results are calculated to
only 15 digits of accuracy.

{pstd}
In any case, {cmd:lrecomp} does not apply the minimum.  When c==t,
{cmd:lrecomp} displays "exactly equal".


{marker example}{...}
{title:Example}

{pstd}
You have run a regression certification test and, among other results,
Stata has calculated {hi:_b[x1]}, the regression coefficient on variable x1.
The known-to-be-correct answer result is 1 and you wish to compare the
calculated {hi:_b[x1]} to that.  You type:

	{cmd:. lrecomp _b[x1] 1}
	{txt:_b[x1]}                {res:11.7}

{pstd}
{hi:_b[x1]} was calculated to {res:11.7} digits.

{pstd}
If two regression coefficients were calculated, {hi:_b[x1]} and
{hi:_b[x2]}, and both should be 1, you could type

	{cmd:. lrecomp _b[x1] 1 _b[x2] 1}

	{txt:_b[x1]}                {res:11.7}
	{txt:_b[x2]}                {res:10.0}

{pstd}
If the standard errors of each of these coefficients were also known to be
1, you might type

	{cmd:. lrecomp _b[x1] 1 _b[x2] 1 _se[x1] 1 _se[x2] 1}

	{txt:_b[x1]}                {res:11.7}
	{txt:_b[x2]}                {res:10.0}
	{txt:_se[x1]}               {res:<exactly equal>}
	{txt:_se[x2]}               {res:<exactly equal>}

{pstd}
or you could type

	{cmd:. lrecomp _b[x1] 1 _b[x2] 1 () _se[x1] 1 _se[x2] 1 ()}

	{txt:_b[x1]}                {res:11.7}
        {txt:_b[x2]}                {res:10.0}
	{hline 26}
	{txt:min}                   {res:10.0}

	{txt:_se[x1]}               {res:<exactly equal>}
	{txt:_se[x2]}               {res:<exactly equal>}
	{hline 26}
	{txt:min}                   {res:15.0}

{pstd}
When all results are exactly equal, {cmd:()} arbitrarily reports 15.0 for
the min.
{p_end}
