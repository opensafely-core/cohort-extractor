{smcl}
{* *! version 1.2.6  12nov2018}{...}
{viewerdialog predict "dialog slogit_p"}{...}
{vieweralsosee "[R] slogit postestimation" "mansection R slogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{viewerjumpto "Postestimation commands" "slogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "slogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "slogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "slogit postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "slogit postestimation##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] slogit postestimation} {hline 2}}Postestimation tools for slogit{p_end}
{p2col:}({mansection R slogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt slogit}:

{synoptset 17 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb slogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb slogit_postestimation##syntax_predict:predict}}predicted
    probabilities, estimated index and its approximate standard error{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy} estimation
results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R slogitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R slogitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt o:utcome(outcome)}]

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt pr}}probability of one of or all the dependent variable outcomes;
the default{p_end}
{synopt:{opt xb}}index for the kth outcome{p_end}
{synopt:{opt stdp}}standard error of the index for the kth outcome{p_end}
{synopt:{opt sc:ores}}equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help fn_pr_out
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.
If you do not specify {cmd:outcome()}, then {cmd:outcome(#1)} is assumed.
{p_end}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, indexes for the kth outcome, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

INCLUDE help pr_stub

{phang}
{opt xb} calculates the index for outcome level k and dimension d.  It returns
a vector of zeros if k = {cmd:e(i_base)}.  A synonym for {opt xb} is
{opt index}.  If {opt outcome()} is not specified, {cmd:outcome(#1)} is
assumed.

{phang}
{opt stdp} calculates the standard error of the index.
A synonym for {opt stdp} is {opt seindex}.
If {opt outcome()} is not specified, {cmd:outcome(#1)} is assumed.

INCLUDE help outcome_opt
{opt outcome()} is not allowed with {opt scores}.

{phang}
{opt scores} calculates the equation-level score variables.  For models with d
dimensions and m levels, d + (d + 1)(m - 1) new variables are created. 

{pmore}
	The first d new variables will contain the scores for the d regression
	equations.

{pmore}
	The next d(m - 1) new variables will contain the scores for the scale
	parameters.

{pmore}
	The last m - 1 new variables will contain scores for the intercepts.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt:{opt pr}}probability of one of or all the dependent variable outcomes{p_end}
{synopt:{opt xb}}index for the kth outcome{p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} and {opt xb} default to the first outcome.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and indexes for
the kth outcome.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}

{pstd}Fit stereotype logistic regression model{p_end}
{phang2}{cmd:. slogit insure age male nonwhite i.site, dim(1) base(1)}
{p_end}

{pstd}Estimate group probabilities{p_end}
{phang2}{cmd:. predict pIndemnity pPrepaid pUninsure}{p_end}
