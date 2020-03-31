{smcl}
{* *! version 1.1.16  23jan2019}{...}
{vieweralsosee "[SVY] jackknife_options" "mansection SVY jackknife_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{viewerjumpto "Syntax" "jackknife_options##syntax"}{...}
{viewerjumpto "Description" "jackknife_options##description"}{...}
{viewerjumpto "Options" "jackknife_options##options"}{...}
{viewerjumpto "Examples" "jackknife_options##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[SVY]} {it:jackknife_options} {hline 2}}More options for jackknife
variance estimation{p_end}
{p2col:}({mansection SVY jackknife_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25 tabbed}{...}
{synopthdr:jackknife_options}
{synoptline}
{syntab:SE}
{synopt :{opt mse}}use MSE formula for variance{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}

{synopt:{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save
	results to {it:filename}{p_end}
{synopt:{opt keep}}keep pseudovalues{p_end}
{synopt:{opt v:erbose}}display the full table legend{p_end}
{synopt:{opt noi:sily}}display any output from {it:command}{p_end}
{synopt:{opt tr:ace}}trace {it:command}{p_end}
{synopt:{opt ti:tle(text)}}use {it:text} as the title for results{p_end}
{synopt:{opt nodrop}}do not drop observations{p_end}
{synopt:{opth reject(exp)}}identify invalid results{p_end}
{synoptline}
{p2colreset}{...}
{phang}
{cmd:saving()}, {cmd:keep}, {cmd:verbose}, {cmd:noisily}, {cmd:trace}, 
{cmd:title()}, {cmd:nodrop}, and {cmd:reject()} are not shown in the dialog
boxes for estimation commands.


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy} accepts more options when performing jackknife variance
estimation.


{marker options}{...}
{title:Options}

{dlgtab:SE}

{phang}
{opt mse} specifies that {cmd:svy} compute the variance by using deviations of
the replicates from the observed value of the statistics based on the entire
dataset.  By default, {cmd:svy} computes the variance by using deviations
of the pseudovalues from their mean.

{phang}
{opt nodots} and {opt dots(#)} specify whether to display replication dots.
By default, one dot character is printed for each successful replication.  A
red `x' is displayed if {it:command} returns an error, `e' is displayed if at
least one value in {it:exp_list} is missing, `n' is displayed if the sample
size is not correct, and a yellow `s' is displayed if the dropped sampling
unit is outside the subpopulation sample.

{phang2}
{opt nodots} suppresses display of the replication dots.

{phang2}
{opt dots(#)} displays dots every {it:#} replications.
{cmd:dots(0)} is a synonym for {cmd:nodots}.

{phang}
{opt saving()}, {opt keep}, {opt verbose}, {opt noisily}, {opt trace},
{opt title()}, {opt nodrop}, {opt reject()}; see
{manhelp svy_jackknife SVY:svy jackknife}.


{marker examples}{...}
{title:Examples}

{phang}
Setup{p_end}
{phang2}
{cmd:. webuse nhanes2}

{phang}
Display survey settings{p_end}
{phang2}
{cmd:. svyset}

{phang}
Fit a linear regression computing jackknife estimates of the standard errors,
displaying the output from each replication{p_end}
{phang2}
{cmd:. svy jackknife, noisily: regress weight height}

{phang}
Compute a jackknife estimate for the standard error of the intercept in the
same regression, adding a new variable to the dataset containing the
pseudovalues for this statistic{p_end}
{phang2}
{cmd:. svy jackknife _b[_cons], keep: regress weight height}
{p_end}
