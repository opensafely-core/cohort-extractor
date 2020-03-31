{smcl}
{* *! version 1.0.1  10feb2020}{...}
{viewerdialog cvplot "dialog cvplot"}{...}
{vieweralsosee "[LASSO] cvplot" "mansection lasso cvplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{viewerjumpto "Syntax" "cvplot##syntax"}{...}
{viewerjumpto "Menu" "cvplot##menu"}{...}
{viewerjumpto "Description" "cvplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "cvplot##linkspdf"}{...}
{viewerjumpto "Options" "cvplot##options"}{...}
{viewerjumpto "Examples" "cvplot##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[LASSO] cvplot} {hline 2}}Plot cross-validation function after lasso{p_end}
{p2col:}({mansection LASSO cvplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
After {cmd:lasso}, {cmd:sqrtlasso}, and {cmd:elasticnet}

{p 8 16 2}
{cmd:cvplot}
[{cmd:,} {help cvplot##cvplot_options:{it:options}}]


{pstd}
After {cmd:ds} and {cmd:po} commands

{p 8 16 2}
{cmd:cvplot,} {opt for(varspec)} 
[{help cvplot##cvplot_options:{it:options}}]


{pstd}
After {cmd:xpo} commands without {cmd:resample}

{p 8 16 2}
{cmd:cvplot,} {opt for(varspec)} 
{opt xfold(#)}
[{help cvplot##cvplot_options:{it:options}}]


{pstd}
After {cmd:xpo} commands with {cmd:resample}

{p 8 16 2}
{cmd:cvplot,} {opt for(varspec)} 
{opt xfold(#)}
{opt resample(#)}
[{help cvplot##cvplot_options:{it:options}}]


{phang}
{it:varspec} is a {varname}, except after {cmd:poivregress}
and {cmd:xpoivregress}, when it is either a {it:varname} or 
{mansection LASSO lassoinfoRemarksandexamplespred_varname:{bf:pred(}{it:varname}{bf:)}}.


{marker cvplot_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:xunits(}{help cvplot##xunitspec:{it:x_unit_spec}}{cmd:)}}x-axis units (scale); default is {cmd:xunits(rlnlambda)}, where {cmd:rlnlambda} denotes lambda on a reverse logarithmic scale{p_end}
{synopt :{cmd:minmax}}add labels for the minimum and maximum x-axis units{p_end}
INCLUDE help for_short
{synopt :{opt alpha(#)}}graph CV function for alpha = {it:#}; default is the selected value alpha*; allowed after {cmd:elasticnet} only{p_end}
{synopt :{cmd:lineopts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of the plotted lines{p_end}

{syntab:S.E. plot}
{synopt :{cmd:se}}show standard-error bands for the CV function{p_end}
{synopt :{cmdab:seop:ts(}{help rcap_options:{it:rcap_options}}{cmd:)}}affect rendition of the standard-error bands{p_end}

{syntab:Reference lines}
{synopt :{cmdab:cvlineop:ts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of reference line identifying the minimum of the CV function or other stopping rule{p_end}
{synopt :{cmd:nocvline}}suppress reference line identifying the minimum of the CV function or other stopping rule{p_end}
{synopt :{cmdab:lslineop:ts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of reference line identifying the value selected using {cmd:lassoselect}{p_end}
{synopt :{cmd:nolsline}}suppress reference line identifying the value selected using {cmd:lassoselect}{p_end}
{synopt :{cmdab:selineop:ts(}{help cline_options:{it:cline_options}}{cmd:)}}affect rendition of reference line identifying the value selected by the one-standard-error rule{p_end}
{synopt :[{cmd:no}]{cmd:seline}}draw or suppress reference line identifying the value selected by the one-standard-error rule; shown by default for {cmd:selection(cv, serule)}{p_end}
{synopt :{cmd:hrefline}}add horizontal reference lines that intersect the vertical reference lines{p_end}
{synopt :{cmdab:rlabelop:ts(}{help cvplot##rlabelopts:{it:r_label_opts}}{cmd:)}}change look of labels for reference line{p_end}

{syntab:Data}
{synopt :{cmd:data(}{help filename:{it:filename}}[{cmd:, replace}]{cmd:)}}save plot data to {it:filename}{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}
{synoptline}
INCLUDE help for_footnote


{marker xunitspec}{...}
{synoptset 35}{...}
{synopthdr:x_unit_spec}
{synoptline}
{synopt :{cmdab:rlnlam:bda}}lambda on a reverse logarithmic scale; the default{p_end}
{synopt :{cmdab:lnlam:bda}}lambda on a logarithmic scale{p_end}
{synopt :{cmd:l1norm}}ell_1-norm of standardized coefficient vector{p_end}
{synopt :{cmd:l1normraw}}ell_1-norm of unstandardized coefficient vector{p_end}
{synoptline}


{marker rlabelopts}{...}
{synoptset 35}{...}
{synopthdr:r_label_opts}
{synoptline}
{synopt :{cmdab:labg:ap(}{help size:{it:size}}{cmd:)}}margin between tick and label{p_end}
{synopt :{cmdab:labsty:le(}{help textstyle:{it:textstyle}}{cmd:)}}overall style of label{p_end}
{synopt :{cmdab:labs:ize(}{help textsizestyle:{it:textsizestyle}}{cmd:)}}size of label{p_end}
{synopt :{cmdab:labc:olor(}{help colorstyle:{it:colorstyle}}{cmd:)}}color and opacity of label{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cvplot} graphs the cross-validation (CV) function after a lasso fit using
{cmd:selection(cv)}, {cmd:selection(adaptive)}, or {cmd:selection(none)}.

{pstd}
{cmd:cvplot} can be used after {cmd:lasso}, {cmd:elasticnet}, {cmd:sqrtlasso},
or any of the lasso inference commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO dslogitQuickstart:Quick start}

        {mansection LASSO dslogitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt xunits(x_unit_spec)} specifies the x-axis units used for graphing the
CV function.  The following {it:x_unit_spec}s are available:

{phang2}
{cmd:rlnlambda} specifies x-axis units lambda on a reverse logarithmic scale.
This is the default.

{phang2}
{cmd:lnlambda} specifies x-axis units lambda on a logarithmic scale.

{phang2}
{cmd:l1norm} specifies x-axis units ell_1-norm of the standardized coefficient
vector.

{phang2}
{cmd:l1normraw} specifies x-axis units ell_1-norm of the unstandardized
coefficient vector.

{phang}
{cmd:minmax} adds labels for the minimum and maximum x-axis units to the graph
of the CV function.

INCLUDE help for_long

{phang}
{opt alpha(#)} graphs the CV function for alpha = {it:#}.  The default is
{opt alpha(alpha*)}, where {it:alpha*} is the selected alpha.  {opt alpha(#)}
may only be specified after {cmd:elasticnet}.

{phang}
{opt lineopts(cline_options)} affects the rendition of the plotted line.
See {manhelpi cline_options G-3}.

{dlgtab:S.E. plot}

{phang}
{cmd:se} shows standard-error bands for the CV function.

{phang}
{opt seopts(rcap_options)} affects the rendition of the standard-error
bands.  See {manhelpi rcap_options G-3}.

{dlgtab:Reference lines}

{phang}
{opt cvlineopts(cline_options)} affects the rendition of the reference
line identifying the minimum CV value, the value selected when the stopping
tolerance is reached, or the grid-minimum value.  See
{manhelpi cline_options G-3}.

{phang}
{cmd:nocvline} suppresses the reference line identifying the minimum CV value,
the value selected when the stopping tolerance is reached, or the grid-minimum
value.

{phang}
{opt lslineopts(cline_options)} affects the rendition of the reference
line identifying the value selected using {cmd:lassoselect}.  See
{manhelpi cline_options G-3}.

{phang}
{cmd:nolsline} suppresses the reference line identifying the value selected
using {cmd:lassoselect}.

{phang}
{opt selineopts(cline_options)} affects the rendition of the reference
line identifying the value selected by the one-standard-error rule.  See
{manhelpi cline_options G-3}.

{phang}
[{cmd:no}]{cmd:seline} draws or suppresses a reference line identifying the
value selected by the one-standard-error rule.  By default, the line is shown
when {cmd:selection(cv, serule)} was the selection method for the lasso.  For
other selection methods, the line is not shown by default.

{phang}
{cmd:hrefline} adds horizontal reference lines that intersect the vertical 
reference lines.

{phang}
{opt rlabelopts(r_label_opts)} changes the look of labels for the reference
line.  The label options {opt labgap(relativesize)}, {opt labstyle(textstyle)},
{opt labsize(textsizestyle)}, and {opt labcolor(colorstyle)} specify details
about how the labels are presented.  See {manhelpi size G-4},
{manhelpi textstyle G-4}, {manhelpi textsizestyle G-4}, and
{manhelpi colorstyle G-4}.

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

{pstd}Graph cross-validation function{p_end}
{phang2}{cmd:. cvplot}

{pstd}Setup{p_end}
{phang2}{cmd:. elasticnet linear mpg i.foreign i.rep78 headroom weight turn}
    {cmd:gear_ratio price trunk length displacement}

{pstd}Graph the cross-validation function for the alpha=0.5 lasso{p_end}
{phang2}{cmd:. cvplot, alpha(0.5)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe, clear}{p_end}
{phang2}{cmd:. xporegress react no2_class no2_home,}
    {cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}
    {cmd:xfolds(5) selection(cv)}

{pstd}Graph the cross-validation function for react for cross-fit
fold 2{p_end}
{phang2}{cmd:. cvplot, for(react) xfold(2)}{p_end}

    {hline}
