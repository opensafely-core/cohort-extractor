{smcl}
{* *! version 1.1.11  14may2018}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "mansection G-2 graphtwowayfpfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfitci" "help twoway_fpfitci"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "help twoway_lfit"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway mband" "help twoway_mband"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{viewerjumpto "Syntax" "twoway_fpfit##syntax"}{...}
{viewerjumpto "Menu" "twoway_fpfit##menu"}{...}
{viewerjumpto "Description" "twoway_fpfit##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_fpfit##linkspdf"}{...}
{viewerjumpto "Options" "twoway_fpfit##options"}{...}
{viewerjumpto "Remarks" "twoway_fpfit##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph twoway fpfit} {hline 2}}Twoway fractional-polynomial prediction plots{p_end}
{p2col:}({mansection G-2 graphtwowayfpfit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:fpfit}
{it:yvar} {it:xvar}
{ifin}
[{it:{help twoway fpfit##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:estc:md:(}{it:{help twoway_fpfit##est_cmd:est_cmd}}{cmd:)}}estimation command; default is
       {cmd:regress}{p_end}
{p2col:{cmdab:est:opts:(}{it:{help twoway_fpfit##est_opts:est_opts}}{cmd:)}}specifies
       {it:est_opts} to estimate the fractional polynomial regression{p_end}

{p2col:{it:{help cline_options}}}change look of predicted line{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
{marker est_cmd}
{it:est_cmd} may be
{helpb clogit},
{helpb glm},
{helpb intreg}, 
{helpb logistic},
{helpb logit},
{helpb mlogit},
{helpb nbreg},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb regress},
{helpb rreg},
{helpb stcox},
{helpb stcrreg},
{helpb streg},
or
{helpb xtgee}.{p_end}
{p 4 6 2}
Options {cmd:estcmd()} and {cmd:estopts()}
are {it:unique}; see {help repeated options}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s,
{cmd:fweight}s, and
{cmd:pweight}s are allowed.  Weights, if specified, affect estimation but
not how the weighted results are plotted.  See {help weight}.

{synoptset 20}{...}
{marker est_opts}{...}
{synopthdr :est_opts}
{synoptline}
{synopt :{opt deg:ree(#)}}degree of fractional polynomial to fit; default is
{cmd:degree(2)}{p_end}

{synopt :{opt nosca:ling}}suppress scaling of first independent variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth po:wers(numlist)}}list of fractional polynomial powers from
which models are chosen{p_end}
{synopt :{opth cent:er(fracpoly##cent_list:cent_list)}}specification of centering for the
independent variables{p_end}
{synopt :{opt all}}include
	out-of-sample observations in generated variables{p_end}

{synopt :{opt log}}display iteration log{p_end}
{synopt :{opt com:pare}}compare models by degree{p_end}
{synopt :{it:{help fracpoly##display_options:display_options}}}control column
         formats and line width{p_end}

{synopt: {it:other_est_opts}}other options allowed by {it:est_cmd}{p_end}
{synoptline}
{p2colreset}{...}
{marker cent_list}{...}
{p 4 6 2}
{it:cent_list} is a comma-separated list with elements
{varlist}{cmd::}{c -(}{opt mean}|{it:#}|{opt no}},
except that the first element may optionally be of the form
{c -(}{opt mean}|{it:#}|{opt no}} to specify the default for all variables.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:fpfit} calculates the prediction for {it:yvar} from 
estimation of a fractional polynomial of {it:xvar} and plots the resulting
curve.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayfpfitQuickstart:Quick start}

        {mansection G-2 graphtwowayfpfitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:estcmd(}{it:{help twoway_fpfit##est_cmd:est_cmd}}{cmd:)}
    specifies the estimation command to be used;
    {cmd:estcmd(regress)} is the default.

{phang}
{cmd:estopts(}{it:est_opts}{cmd:)}
    specifies the options to estimate the fractional polynomial regression
    from which the curve will be predicted.  Available {it:est_opts} are

{phang2}
{opt degree(#)} determines the degree of FP to be fit.  The default is
{cmd:degree(2)}, that is, a model with two power terms.

{phang2}
{opt noscaling} suppresses scaling of {it:{help varname:xvar1}} and its powers.

{phang2}
{opt noconstant} suppresses the regression constant if this is
permitted by {it:est_cmd}.

{phang2}
{opth powers(numlist)} is the set of FP powers from which models are to be
chosen.  The default is {cmd:powers(-2, -1, -.5, 0, .5, 1, 2, 3)} (0 means
log).

{phang2}
{opt center(cent_list)} defines the centering for the covariates
{it:{help varname:xvar1}}, {it:xvar2}, ..., {it:{help varlist:xvarlist}}.  The
default is {cmd:center(mean)}.  A typical item in {it:cent_list} is
{varlist}{cmd::}{c -(}{cmd:mean}|{it:#}|{cmd:no}}.  Items are separated by
commas.   The first item is special because {it:varlist}{cmd::} is optional,
and if omitted, the default is (re)set to the specified value ({opt mean} or
{it:#} or {opt no}).  For example, {cmd:center(no, age:mean)} sets the default
to {opt no} and sets the centering for {opt age} to {opt mean}.

{phang2}
{cmd:all} includes out-of-sample observations when generating the best-fitting
FP powers of {it:{help varname:xvar_1}}, {it:xvar_2}, etc.  By default, the
generated FP variables contain missing values outside the estimation sample.

{phang2}
{cmd:log} displays deviances and (for {cmd:regress}) residual standard
deviations for each FP model fit.

{phang2}
{cmd:compare} reports a closed-test comparison between FP models.

{marker display_options}{...}
{phang2}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{phang2}
{it:other_est_opts} are options appropriate to the {it:est_cmd};
see the documentation for that {it:est_cmd}.  For example, for {opt stcox},
{it:other_est_opts} may include {opt efron} or some alternate method
for handling tied failures.

{phang}
{it:cline_options}
     specify how the prediction line is rendered; see
     {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway fpfit##remarks1:Typical use}
	{help twoway fpfit##remarks2:Cautions}
	{help twoway fpfit##remarks3:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:twoway} {cmd:fpfit} is nearly always used in conjunction with
other {cmd:twoway} plottypes, such as

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight || fpfit mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight || fpfit mpg weight":click to run})}
{* graph gtfpfit1}{...}


{marker remarks2}{...}
{title:Cautions}

{pstd}
Do not use {cmd:twoway} {cmd:fpfit} when specifying the
{it:axis_scale_options} {helpb axis_scale_options:yscale(log)} or
{helpb axis_scale_options:xscale(log)}
to create log scales.  Typing

{phang2}
	{cmd:. scatter mpg weight, xscale(log) || fpfit mpg weight}

{pstd}
will produce a curve that will be fit from a fractional polynomial
regression of {cmd:mpg} on {cmd:weight} rather than {cmd:log(weight)}.


{marker remarks3}{...}
{title:Use with by()}

{pstd}
{cmd:fpfit} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

{phang2}
	{cmd:. scatter mpg weight || fpfit mpg weight ||, by(foreign, total row(1))}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight || fpfit mpg weight ||, by(foreign, total row(1))":click to run})}
{* graph gtfpfit2}{...}
