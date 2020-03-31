{smcl}
{* *! version 1.0.3  21mar2019}{...}
{viewerdialog "estat teffects" "dialog erm_estat"}{...}
{vieweralsosee "[ERM] estat teffects" "mansection ERM estatteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "help eintreg postestimation"}{...}
{vieweralsosee "[ERM] eoprobit postestimation" "help eoprobit postestimation"}{...}
{vieweralsosee "[ERM] eprobit postestimation" "help eprobit postestimation"}{...}
{vieweralsosee "[ERM] eregress postestimation" "help eregress postestimation"}{...}
{viewerjumpto "Syntax" "erm_estat_teffects##syntax"}{...}
{viewerjumpto "Menu" "erm_estat_teffects##menu"}{...}
{viewerjumpto "Description" "erm_estat_teffects##description"}{...}
{viewerjumpto "Links to PDF documentation" "erm_estat_teffects##linkspdf"}{...}
{viewerjumpto "Options" "erm_estat_teffects##options"}{...}
{viewerjumpto "Examples" "erm_estat_teffects##examples"}{...}
{viewerjumpto "Stored results" "erm_estat_teffects##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[ERM] estat teffects} {hline 2}}Average treatment effects for
extended regression models{p_end}
{p2col:}({mansection ERM estatteffects:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:estat teffects}
[{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt ate}}estimate average treatment effect; the default{p_end}
{synopt :{opt atet}}estimate average treatment effect on the treated{p_end}
{synopt :{opt pom:ean}}estimate potential-outcome mean{p_end}
{synopt :{opth tl:evel(numlist)}}calculate treatment effects 
	or potential-outcome means for specified 
	treatment levels{p_end}
{synopt :{opth outl:evel(numlist)}}calculate treatment effects or 
	potential-outcome means for specified levels 
	of ordinal dependent variable{p_end}
{synopt :{opth subpop:(erm_estat_teffects##subspec:subspec)}}estimate for
subpopulation{p_end}

{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{help erm_estat_teffects##display_options:{it:display_options}}}control
columns and column formats, row spacing, line width and 
factor-variable labeling{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat teffects} estimates the average treatment effect, average treatment
effect on the treated, and potential-outcome mean for ERMs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM estatteffectsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt ate} estimates the average treatment effect (ATE).  This is the default.

{phang} 
{opt atet} estimates the average treatment effect on the treated 
(ATET).  For binary treatments, the ATET is reported for 
the treated group subpopulation.  For ordinal treatments, by default, the 
ATET is reported for the first noncontrol treatment group 
subpopulation.  You can use the {opt subpop()} option to 
calculate the ATET for a different treatment group.

{phang} 
{opt pomean} estimates the potential-outcome mean (POM).

{phang}
{opth tlevel(numlist)} specifies the treatment levels for which treatment
effects or POMs are calculated.  By default, the treatment
effects are computed for all noncontrol treatment levels, and the
POMs are computed for all treatment levels.

{phang}
{opth outlevel(numlist)} specifies the levels of the ordinal dependent variable
for which treatment effects or POMs are to be calculated.  By
default, treatment effects or POMs are computed for all
levels of the ordinal dependent variable.  This option is only available after
{cmd:eoprobit} and {cmd:xteoprobit}.

{marker subspec}{...}
{phang}
{cmd:subpop(}[{varname}] [{help if:{it:if}}]{cmd:)} 
specifies the subpopulation for which the ATE, ATET, and POM are calculated.
The subpopulation is identified by the indicator variable, by the {cmd:if}
expression, or by both.  A 0 indicates that the observation be excluded, a
nonzero indicates that it be included, and a missing value indicates that it
be treated as outside of the population (and thus ignored).  For instance, for
an ordinal treatment {cmd:trtvar} with levels 1, 2, and 3, you can specify
{cmd:subpop(if trtvar==3)} to obtain the ATETs for {cmd:trtvar} = 3.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt vsquish},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.

{phang2}
{opt noci}
suppresses confidence intervals from being reported in the coefficient table.

{phang2}
{opt nopvalues}
suppresses p-values and their test statistics from being reported in the
coefficient table.

{phang2}
{opt vsquish} 
specifies that the blank space separating factor-variable terms or
time-series-operated variables from other variables in the model be
suppressed.

{phang2}
{opt nofvlabel} displays factor-variable level values rather than attached
value labels.  This option overrides the {cmd:fvlabel} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrap(#)} allows long value labels to wrap the first {it:#}
lines in the coefficient table.  This option overrides the {cmd:fvwrap}
setting; see {helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrapon(style)} specifies whether value labels that wrap will
break at word boundaries or break based on available space.

{phang3}
{cmd:fvwrapon(word)}, the default, specifies that value labels break at
word boundaries.

{phang3}
{cmd:fvwrapon(width)} specifies that value labels break based on available
space.

{phang3}
This option overrides the {cmd:fvwrapon} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt cformat(%fmt)} specifies how to format estimates, standard
errors, and confidence limits in the estimates table.  The maximum format
width is 9.

{phang2}
{opt pformat(%fmt)} specifies how to format p-values in the
estimates table.  The maximum format width is 5.

{phang2}
{opt sformat(%fmt)} specifies how to format test statistics in the 
estimates table.  The maximum format width is 8.

{phang2}
{opt nolstretch} specifies that the width of the estimates table not
be automatically widened to accommodate longer variable names.  The default,
{opt lstretch}, is to automatically widen the estimates table up to
the width of the Results window.
To change the default, use {opt set} {opt lstretch} {opt off}.
{opt nolstretch} is not shown in the dialog box.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse wageed}{p_end}
{phang2}
{cmd:. eregress wage c.age##c.age tenure, extreat(college) vce(robust)}

{pstd}
Average treatment effect on the treated{p_end}
{phang2}
{cmd:. estat teffects, atet}

{pstd}
Average treatment effect{p_end}
{phang2}
{cmd:. estat teffects}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat teffects} stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Macros}{p_end}
{synopt :{cmd:r(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:r(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:r(clustvar)}}name of cluster variable{p_end}

{p2col 5 16 20 2: Matrices}{p_end}
{synopt :{cmd:r(b)}}estimates{p_end}
{synopt :{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt :{cmd:r(table)}}matrix containing the estimates with their standard
	  errors, test statistics, p-values, and confidence intervals{p_end}
{p2colreset}{...}
