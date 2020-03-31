{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog coefpath "dialog coefpath"}{...}
{vieweralsosee "[LASSO] coefpath" "mansection lasso coefpath"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{viewerjumpto "Syntax" "coefpath##syntax"}{...}
{viewerjumpto "Menu" "coefpath##menu"}{...}
{viewerjumpto "Description" "coefpath##description"}{...}
{viewerjumpto "Links to PDF documentation" "coefpath##linkspdf"}{...}
{viewerjumpto "Options" "coefpath##options"}{...}
{viewerjumpto "Examples" "coefpath##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[LASSO] coefpath} {hline 2}}Plot path of coefficients after lasso{p_end}
{p2col:}({mansection LASSO coefpath:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
After {cmd:lasso}, {cmd:sqrtlasso}, and {cmd:elasticnet}

{p 8 16 2}
{opt coefpath}
[{cmd:,} {help coefpath##coefpath_options:{it:options}}]


{pstd}
After {cmd:ds} and {cmd:po} commands

{p 8 16 2}
{opt coefpath,} {opt for(varspec)}
[{help coefpath##coefpath_options:{it:options}}]


{pstd}
After {cmd:xpo} commands without {cmd:resample}

{p 8 16 2}
{opt coefpath,} {opt for(varspec)} 
{opt xfold(#)}
[{help coefpath##coefpath_options:{it:options}}]


{pstd}
After {cmd:xpo} commands with {cmd:resample}

{p 8 16 2}
{cmd:coefpath,} {opt for(varspec)} 
{opt xfold(#)}
{opt resample(#)}
[{help coefpath##coefpath_options:{it:options}}]


{phang}
{it:varspec} is a {varname}, except after {cmd:poivregress}
and {cmd:xpoivregress}, when it is either {it:varname} or 
{mansection LASSO lassoinfoRemarksandexamplespred_varname:{bf:pred(}{it:varname}{bf:)}}.


{marker coefpath_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:xunits(}{help coefpath##xunitspec:{it:x_unit_spec}}{cmd:)}}x-axis units (scale); default is {cmd:xunits(l1norm)}{p_end}
{synopt :{cmd:minmax}}adds minimum and maximum values to the x axis{p_end}
INCLUDE help for_short
{synopt :{opt alpha(#)}}graph coefficient paths for alpha={it:#}; default is the selected value alpha*; only allowed after {cmd:elasticnet}{p_end}
{synopt :{opt raw:coefs}}graph unstandardized coefficient paths{p_end}

{syntab:Reference line}
{synopt :{cmdab:rlop:ts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of reference line{p_end}
{synopt :{cmd:norefline}}suppress plotting reference line{p_end}

{syntab:Path}
{synopt :{cmd:lineopts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of all coefficient paths; not allowed when there are 100 or more coefficients{p_end}
{synopt :{cmd:line}{it:#}{cmd:opts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of coefficient path {it:#}; not allowed when there are 100 or more coefficients{p_end}
{synopt :{cmd:mono}}graph coefficient paths using a single line; default is {cmd:mono} for 100 or more coefficients{p_end}
{synopt :{cmd:monoopts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of line used to graph coefficient paths when {cmd:mono} is specified{p_end}

{syntab:Data}
{synopt :{cmd:data(}{help filename:{it:filename}}[{cmd:, replace}]{cmd:)}}save plot data to {it:filename}{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
INCLUDE help for_footnote


{marker xunitspec}{...}
{synoptset 35}{...}
{synopthdr:x_unit_spec}
{synoptline}
{synopt :{cmd:l1norm}}ell_1-norm of standardized coefficient vector; the default{p_end}
{synopt :{cmd:l1normraw}}ell_1-norm of unstandardized coefficient vector{p_end}
{synopt :{cmdab:lnlam:bda}}lambda on a logarithmic scale{p_end}
{synopt :{cmdab:rlnlam:bda}}lambda on a reverse logarithmic scale{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:coefpath} graphs the coefficient paths after any lasso fit using
{cmd:selection(cv)}, {cmd:selection(adaptive)}, or {cmd:selection(none)}.  A
line is drawn for each coefficient that traces its value over the searched
values of the lasso penalty parameter lambda or over the ell_1-norm of the
fitted coefficients that result from lasso selection using those values of
lambda.

{pstd}
{cmd:coefpath} can be used after {cmd:lasso}, {cmd:elasticnet},
{cmd:sqrtlasso}, or any of the lasso inference commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO coefpathQuickstart:Quick start}

        {mansection LASSO coefpathRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt xunits(x_unit_spec)} specifies the x-axis units used for graphing the
coefficient paths.  The following {it:x_unit_spec}s are available:

{phang2}
{cmd:l1norm} specifies x-axis units ell_1-norm of the standardized coefficient
vector.  This is the default.

{phang2}
{cmd:l1normraw} specifies x-axis units ell_1-norm of the unstandardized
coefficient vector.

{phang2}
{cmd:lnlambda} specifies x-axis units lambda on a logarithmic scale.

{phang2}
{cmd:rlnlambda} specifies x-axis units lambda on a reverse logarithmic
scale.

{phang}
{cmd:minmax} adds minimum and maximum values to the x axis.

INCLUDE help for_long

{phang}
{opt alpha(#)} graphs coefficient paths for alpha = {it:#}.  The default is
{opt alpha(alpha*)}, where {it:alpha*} is the selected alpha.  {opt alpha(#)}
may only be specified after {cmd:elasticnet}.

{phang}
{cmd:rawcoefs} specifies that unstandardized coefficient paths be graphed.  By
default, coefficients of standardized variables (mean 0 and standard deviation
1) are graphed.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.  See
{manhelpi cline_options G-3}.

{phang}
{cmd:norefline} suppresses plotting the reference line.

{dlgtab:Path}

{phang}
{opt lineopts(cline_options)} affects the rendition of all coefficient
paths.  See {manhelpi cline_options G-3}.  {cmd:lineopts()} is not allowed when
there are 100 or more coefficients.

{phang}
{cmd:line}{it:#}{cmd:opts(}{it:cline_options}{cmd:)} affects the rendition of
coefficient path {it:#}.  See {manhelpi cline_options G-3}.
{cmd:line}{it:#}{cmd:opts()} is not allowed when there are 100 or more
coefficients.

{phang}
{cmd:mono} graphs the coefficient paths using a single line.  {cmd:mono} is the
default when there are 100 or more coefficients in the lasso.

{phang}
{opt monoopts(cline_options)} affects the rendition of the line used
to graph the coefficient paths when {cmd:mono} is specified.  See
{manhelpi cline_options G-3}.

{dlgtab:Data}

{phang}
{cmd:data(}{help filename:{it:filename}} [{cmd:, replace}]{cmd:)} saves the
plot data to a Stata data file.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and options for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. set seed 1234}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
    {cmd:gear_ratio price trunk length displacement}

{pstd}Graph the coefficient paths{p_end}
{phang2}{cmd:. coefpath}

{pstd}Setup{p_end}
{phang2}{cmd:. elasticnet linear mpg i.foreign i.rep78 headroom weight}
    {cmd:turn gear_ratio price trunk length displacement}

{pstd}Graph the coefficient paths for the alpha=0.5 lasso{p_end}
{phang2}{cmd:. coefpath, alpha(0.5)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe, clear}{p_end}
{phang2}{cmd:. xporegress react no2_class no2_home,}
    {cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
    {cmd:xfolds(5) selection(cv)}

{pstd}Graph the coefficient paths for react for cross-fit fold 2{p_end}
{phang2}{cmd:. coefpath, for(react) xfold(2)}{p_end}

    {hline}
