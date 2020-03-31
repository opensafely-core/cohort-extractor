{smcl}
{* *! version 1.0.2  12dec2018}{...}
{vieweralsosee "prdocumented" "help previously documented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[MI] estimation" "help mi estimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] rreg" "help rreg"}{...}
{viewerjumpto "Syntax" "_qreg##syntax"}{...}
{viewerjumpto "Description" "_qreg##description"}{...}
{viewerjumpto "Options" "_qreg##options"}{...}
{viewerjumpto "Saved results" "_qreg##saved_results"}{...}
{pstd}
{cmd:_qreg} continues to work but, as of Stata 13, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:[R] _qreg} {hline 2}}Internal estimation command for quantile regression{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:_qreg} [{depvar} [{indepvars}] {ifin} {weight}]
	[{cmd:,} {it:options}]

{synoptset 21}{...}
{marker options}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt qu:antile(#)}}estimate {it:#} quantile; default is {cmd:quantile(.5)}{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ac:curacy(#)}}relative accuracy required for linear programming algorithm; should not be specified{p_end}
{synopt :{it:{help _qreg##_qreg_optimize:optimization_options}}}control the optimization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:_qreg} allows {cmd:fweight}s, {cmd:aweight}s, and {cmd:iweight}s;
	see {help weight}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_qreg} is the internal estimation command for quantile regression.
{cmd:_qreg} is not intended to be used directly; see 
{it:Methods and formulas} in {bind:{bf:[R] qreg}}.


{marker options}{...}
{marker _qreg_optimize}{...}
{title:Options}

{phang}{opt quantile(#)} specifies the quantile to be estimated and should be
a number between 0 and 1, exclusive.
The default value of 0.5 corresponds to the median.

{phang}{opt level(#)}; see 
{helpb estimation options##level():[R] estimation options}.

{phang}{opt accuracy(#)} should not be specified; it specifies the relative
accuracy required for the linear programming algorithm.  If the potential for
improving the sum of weighted deviations by deleting an observation from the
basis is less than this on a percentage basis, the algorithm will be said to
have converged.  The default value is 10^-10.

{phang}{it:optimization_options}: {opt iter:ate(#)}, [{cmdab:no:}]{opt lo:g}, 
{opt tr:ace}.  {opt iterate()} specifies the maximum number of iterations;
{opt log}/{opt nolog} specifies whether to show the iteration log
(see {cmd:set iterlog} in {manhelpi set_iter R:set iter}); and
{opt trace} specifies that the iteration log should include the current
parameter vector.  These options are seldom used.


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:_qreg} saves the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:r(q)}}quantile requested{p_end}
{synopt:{cmd:r(q_v)}}value of the quantile{p_end}
{synopt:{cmd:r(sum_w)}}sum of the weights{p_end}
{synopt:{cmd:r(sum_adev)}}sum of absolute deviations{p_end}
{synopt:{cmd:r(sum_rdev)}}sum of raw deviations{p_end}
{synopt:{cmd:r(f_r)}}residual density estimate{p_end}
{synopt:{cmd:r(ic)}}number of iterations{p_end}
{synopt:{cmd:r(convcode)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}
{p2colreset}{...}
