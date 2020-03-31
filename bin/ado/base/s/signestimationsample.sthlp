{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[P] signestimationsample" "mansection P signestimationsample"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] datasignature" "help datasignature"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{viewerjumpto "Syntax" "signestimationsample##syntax"}{...}
{viewerjumpto "Description" "signestimationsample##description"}{...}
{viewerjumpto "Links to PDF documentation" "signestimationsample##linkspdf"}{...}
{viewerjumpto "Remarks" "signestimationsample##remarks"}{...}
{viewerjumpto "Stored results" "signestimationsample##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[P] signestimationsample} {hline 2}}Determine whether the
	estimation sample has changed{p_end}
{p2col:}({mansection P signestimationsample:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:signestimationsample}
{it:{help varlist}}

{p 8 12 2}
{cmd:checkestimationsample}


{marker description}{...}
{title:Description}

{pstd}
{cmd:signestimationsample} and 
{cmd:checkestimationsample} are easy-to-use interfaces into 
{cmd:datasignature} for use with estimation commands; 
see {manhelp datasignature D}.

{pstd}
{cmd:signestimationsample} obtains a data signature for the estimation 
sample and stores it in {cmd:e()}.

{pstd}
{cmd:checkestimationsample} 
obtains a data signature and compares it with that stored by 
{cmd:signestimationsample} and, if they are different, 
reports 
{err:data have changed since estimation}; r(459).

{pstd} 
If you just want to know whether any of the data in memory have changed
since they were last saved, 
see {manhelp describe D}.
Examine stored result {cmd:r(changed)} 
after {cmd:describe}; it will be 
{cmd:0} if the data have not changed and {cmd:1} otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P signestimationsampleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help signestimationsample##use:Using signestimationsample and checkestimationsample}
	{help signestimationsample##signing:Signing}
	{help signestimationsample##checking:Checking}
	{help signestimationsample##weights:Handling of weights}
	{help signestimationsample##seldom:Do not sign unnecessarily}


{marker use}{...}
{title:Using signestimationsample and checkestimationsample}

{pstd}
Estimators often come as a suite of commands: the estimation command itself
(say, {cmd:myest}) and postestimation commands such as {cmd:predict},
{cmd:estat}, or even {cmd:myest_stats}.  The calculations made by the
postestimation commands are sometimes appropriate for use with any set of data
values -- not just the data used for estimation -- and sometimes not.  For
example, predicted values can be calculated with any set of explanatory
variables, whereas scores are valid only if calculated using the original
data.

{pstd}
Postestimation calculations that are valid only when made using the 
estimation sample are the exception, but when they arise, 
{cmd:signestimationsample} and {cmd:checkestimationsample} provide the solution.
The process is as follows:

{p 8 12 2}
1.  At the time of estimation, sign the estimation sample (store the data's
    signature in {cmd:e()}).

{p 8 12 2}
2.  At the time of use, obtain the signature of the data in memory and 
    compare it with the original stored previously.


{marker signing}{...}
{title:Signing}

{pstd}
To sign the estimation sample, include in your estimation command 
the following line after {cmd:e(sample)} is set (that is, after {cmd:ereturn} 
{cmd:post}):

	{cmd:signestimationsample `varlist'}

{pstd}
{cmd:`varlist'} should contain all variables used in estimation, string 
and numeric, used directly or indirectly, so you may in fact code

	{cmd:signestimationsample `lhsvar' `rhsvars' `clustervar'}

{pstd} 
or something similar.  If you are implementing a time-series estimator, 
do not forget to include the time variable:

	{cmd:quietly tsset}
	{cmd:signestimationsample `r(timevar)' `lhsvar' `rhsvars' `othervars'}

{pstd}
The time variable may be among the {cmd:`rhsvars'}, but it does not matter
if time is specified twice.

{pstd}
If you are implementing an xt estimator, do not forget to include the 
panel variable and the optional time variable:

	{cmd:quietly xtset}
	{cmd:signestimationsample `r(panelvar)' `r(timevar)' `lhsvar' `rhsvars' ///}
					{cmd:`clustervar'}


{pstd}
In any case, specify all relevant variables and don't worry about
duplicates.  {cmd:signestimationsample} produces no output, but behind the
scenes, it adds two new results to {cmd:e()}:

{p 8 12 2}
o  {cmd:e(datasignature)} -- the signature formed by the variables 
    specified in the observations for which {cmd:e(sample)} = 1

{p 8 12 2}
o  {cmd:e(datasignaturevars)} -- the names of the variables used in forming
    the signature


{marker checking}{...}
{title:Checking}

{pstd}
Now that the signature is stored, include the following line
in the appropriate place in your postestimation command:

	{cmd:checkestimationsample}

{pstd}
{cmd:checkestimationsample} will compare {cmd:e(datasignature)} with a newly
obtained signature based on {cmd:e(datasignaturevars)} and {cmd:e(sample)}.
If the data have not changed, the results will match, and
{cmd:checkestimationsample} will silently return.  Otherwise, it will issue
the error message {err:data have changed since estimation} and abort with
return code 459.


{marker weights}{...}
{title:Handling of weights}

{pstd}
When you code

	{cmd:signestimationsample `lhsvar' `rhsvars' `clustervar'}

{pstd}
and 

	{cmd:checkestimationsample}

{pstd}
weights are handled automatically.

{pstd}
That is, when you {cmd:signestimationsample}, the command looks
for {cmd:e(wexp)} and automatically includes any weighting variables in the
calculation of the checksum.  {cmd:checkestimationsample} does the same thing.


{marker seldom}{...}
{title:Do not sign unnecessarily}

{pstd}
{cmd:signestimationsample} and {cmd:checkestimationsample}
are excellent solutions for restricting postestimation 
calculations to the estimation sample.  However, most
statistics do not need to be so restricted.  If none of your postestimation
commands need to {cmd:checkestimationsample}, do not bother to
{cmd:signestimationsample}.

{pstd}
Calculation of the checksum requires time.  It's not much, but neither is 
it zero.  On a 2.8-GHz computer, calculating the checksum over 100 variables 
and 50,000 observations requires about a quarter of a second.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:signestimationsample} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of
                                   checksum{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{p2colreset}{...}

{pstd}
The format of the stored signature is that produced by 
{cmd:datasignature,} {cmd:fast} {cmd:nonames};
see {manhelp datasignature D}.
{p_end}
