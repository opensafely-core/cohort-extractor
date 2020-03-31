{smcl}
{* *! version 1.1.24  11dec2018}{...}
{viewerdialog rreg "dialog rreg"}{...}
{vieweralsosee "[R] rreg" "mansection R rreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rreg postestimation" "help rreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] qreg" "help qreg"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "rreg##syntax"}{...}
{viewerjumpto "Menu" "rreg##menu"}{...}
{viewerjumpto "Description" "rreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "rreg##linkspdf"}{...}
{viewerjumpto "Options" "rreg##options"}{...}
{viewerjumpto "Examples" "rreg##examples"}{...}
{viewerjumpto "Stored results" "rreg##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] rreg} {hline 2}}Robust regression{p_end}
{p2col:}({mansection R rreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:rreg} {depvar} [{indepvars}] {ifin} 
[{cmd:,} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Model}
{synopt :{opt tu:ne(#)}}use {it:#} as the biweight tuning constant; default is
{cmd:tune(7)}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}
{synopt :{opth g:enwt(newvar)}}create {it:newvar} containing the weights assigned
to each observation{p_end}
{synopt :{it:{help rreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{it:{help rreg##optimize_options:optimization_options}}}control the optimization process; seldom used{p_end}
{synopt :{opt g:raph}}graph weights during convergence{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators; see 
{help tsvarlist}.{p_end}
{p 4 6 2}{cmd:by}, {opt mfp}, {cmd:mi estimate}, {cmd:rolling},
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp rreg_postestimation R:rreg postestimation} for features
available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Other > Robust regression}


{marker description}{...}
{title:Description}

{pstd}
{opt rreg} performs one version of robust regression of {depvar} on
{indepvars}.

{pstd}
Also see {it:{mansection R regressRemarksandexamplesRobuststandarderrors:Robust standard errors}}
in {bf:[R] regress} for standard regression with robust variance
estimates and {manlink R qreg} for quantile (including median or
least-absolute-residual) regression.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rregQuickstart:Quick start}

        {mansection R rregRemarksandexamples:Remarks and examples}

        {mansection R rregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt tune(#)} is the biweight tuning constant.  The default is 7, meaning 
seven times the median absolute deviation from the median residual; see
{mansection R rregMethodsandformulas:{it:Methods and formulas}} in 
{bf:[R] rreg}.  Lower tuning constants downweight outliers rapidly but may lead
to unstable estimates (less than 6 is not recommended).  Higher tuning
constants produce milder downweighting.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}. 

{phang}
{opth genwt(newvar)} creates the new variable {it:newvar} containing the
weights assigned to each observation.

INCLUDE help displayopts_list

{marker optimize_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimization_options}: 
{opt iter:ate(#)}, {opt tol:erance(#)}, [{cmd:no}]{cmd:log}.
{opt iterate()} specifies the maximum number of iterations; iterations stop
when the maximum change in weights drops below {opt tolerance()}; and
{opt log}/{opt nolog} specifies whether to show the iteration log
(see {cmd:set iterlog} in {manhelpi set_iter R:set iter}).
These options are seldom used.

{phang}
{opt graph} allows you to graphically watch the convergence of the
iterative technique.  The weights obtained from the most recent round of
estimation are graphed against the weights obtained from the previous round.

{pstd}
The following option is available with {opt rreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Robust regression{p_end}
{phang2}{cmd:. rreg mpg foreign#c.weight foreign}

{pstd}Same as above, but save estimated weights in {cmd:genwt(w)}{p_end}
{phang2}{cmd:. rreg mpg foreign#c.weight foreign, genwt(w)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rreg} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(genwt)}}variable containing the weights{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(model)}}{cmd:ols}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
