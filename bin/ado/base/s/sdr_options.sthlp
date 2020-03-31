{smcl}
{* *! version 1.0.15  23jan2019}{...}
{vieweralsosee "[SVY] sdr_options" "mansection SVY sdr_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{viewerjumpto "Syntax" "sdr_options##syntax"}{...}
{viewerjumpto "Description" "sdr_options##description"}{...}
{viewerjumpto "Options" "sdr_options##options"}{...}
{viewerjumpto "Examples" "sdr_options##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[SVY]} {it:sdr_options} {hline 2}}More options for SDR variance estimation{p_end}
{p2col:}({mansection SVY sdr_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25 tabbed}{...}
{synopthdr:sdr_options}
{synoptline}
{syntab:SE}
{synopt :{opt mse}}use MSE formula for variance{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}

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
{cmd:svy} accepts more options when performing successive difference
replication (SDR) variance estimation.  See {manhelp svy_sdr SVY:svy sdr} for a
complete discussion.


{marker options}{...}
{title:Options}

{dlgtab:SE}

{phang}
{opt mse} specifies that {cmd:svy} compute the variance by using deviations of
the replicates from the observed value of the statistics based on the entire
dataset.  By default, {cmd:svy} computes the variance by using deviations
of the replicates from their mean.

INCLUDE help svy_dots

{phang}
{opt saving()}, {opt verbose}, {opt noisily}, {opt trace}, {opt title()},
{opt nodrop}, and {opt reject()}; see {manhelp svy_sdr SVY:svy sdr}.


{marker examples}{...}
{title:Examples}

{phang}
Setup{p_end}
{phang2}
{cmd:. webuse ss07ptx}

{phang}
Display survey settings{p_end}
{phang2}
{cmd:. svyset}

{phang}
Estimate the mean of a variable over two subpopulations using successive
difference replications to estimate the standard errors, displaying dots every
20 iterations{p_end}
{phang2}
{cmd:. svy sdr, dots(20): mean agep, over(sex)}

{phang}
Estimate the difference of the means computed above, creating file
{cmd:newdata.dta} consisting of a variable containing the replicates{p_end}
{phang2}
{cmd:. svy sdr diff = (_b[c.agep@1.sex] - _b[c.agep@2.sex]), saving(newdata):}
       {cmd:mean agep, over(sex)}
{p_end}
