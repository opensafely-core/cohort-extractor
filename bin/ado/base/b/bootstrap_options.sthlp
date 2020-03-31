{smcl}
{* *! version 1.0.16  23jan2019}{...}
{vieweralsosee "[SVY] bootstrap_options" "mansection SVY bootstrap_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{viewerjumpto "Syntax" "bootstrap_options##syntax"}{...}
{viewerjumpto "Description" "bootstrap_options##description"}{...}
{viewerjumpto "Options" "bootstrap_options##options"}{...}
{viewerjumpto "Examples" "bootstrap_options##examples"}{...}
{p2colset 1 28 24 2}{...}
{p2col:{bf:[SVY]} {it:bootstrap_options} {hline 2}}More options for bootstrap
variance estimation{p_end}
{p2col:}({mansection SVY bootstrap_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25 tabbed}{...}
{synopthdr:bootstrap_options}
{synoptline}
{syntab:SE}
{synopt :{opt mse}}use MSE formula for variance{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}
{synopt :{opt bsn(#)}}bootstrap mean-weight adjustment{p_end}

{synopt :{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:, ...)}}}save
	results to {it:filename}{p_end}
{synopt :{opt v:erbose}}display the full table legend{p_end}
{synopt :{opt noi:sily}}display any output from {it:command}{p_end}
{synopt :{opt tr:ace}}trace {it:command}{p_end}
{synopt :{opt ti:tle(text)}}use {it:text} as the title for results{p_end}
{synopt :{opt nodrop}}do not drop observations{p_end}
{synopt :{opth reject(exp)}}identify invalid results{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:saving()}, {cmd:verbose}, {cmd:noisily}, {cmd:trace}, {cmd:title()}, 
{cmd:nodrop}, and {cmd:reject()} are not shown in the dialog boxes for
estimation commands.


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy} accepts more options when performing bootstrap variance estimation.
See {manhelp svy_bootstrap SVY:svy bootstrap} for a complete discussion.


{marker options}{...}
{title:Options}

{dlgtab:SE}

{phang}
{opt mse} specifies that {cmd:svy} compute the variance by using deviations of
the replicates from the observed value of the statistics based on the entire
dataset.  By default, {cmd:svy} computes the variance by using the deviations
of the replicates from their mean.

INCLUDE help svy_dots

{phang}
{opt bsn(#)} specifies that {it:#} bootstrap replicate-weight variables were
used to generate each bootstrap mean-weight variable specified in the
{opt bsrweight()} option of {helpb svyset}.
The {opt bsn()} option of {opt bootstrap} overrides the {opt bsn()} option of
{helpb svyset}.

{phang}
{opt saving()}, {opt verbose}, {opt noisily}, {opt trace}, {opt title()},
{opt nodrop}, and {opt reject()}; see {manhelp svy_bootstrap SVY:svy bootstrap}.


{marker examples}{...}
{title:Examples}

{phang}
Setup{p_end}
{phang2}
{cmd:. webuse nmihs_bs}

{phang}
Display survey settings{p_end}
{phang2}
{cmd:. svyset}

{phang}
Fit a logistic regression using bootstrap to estimate standard errors,
displaying a dot every 10 replications{p_end}
{phang2}
{cmd:. svy bootstrap, dots(10): logistic lowbw age highbp}

{phang}
Fit the same regression, computing the variance estimator using deviation
from the value of the parameters estimated using the final weights contained
in variable {cmd:finwgt}{p_end}
{phang2}
{cmd:. svy bootstrap, mse: logistic lowbw age highbp}

{phang}
Compute bootstrap standard errors for the difference between birthweights for
two subpopulations; do not display replication dots{p_end}
{phang2}
{cmd:. svy bootstrap diff = (_b[c.birthwgt@1.childsex] -}
          {cmd: _b[c.birthwgt@2.childsex]), nodots:}
          {cmd:mean birthwgt, over(childsex)}
{p_end}
