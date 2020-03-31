{smcl}
{* *! version 1.0.0  25feb2019}{...}
{viewerdialog estat "dialog dsge_estat, message(-covariance-) name(dsge_estat_covariance)"}{...}
{vieweralsosee "[DSGE] estat covariance" "mansection DSGE estatcovariance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 3e" "mansection DSGE Intro3e"}{...}
{viewerjumpto "Syntax" "dsge estat covariance##syntax"}{...}
{viewerjumpto "Menu for estat" "dsge estat covariance##menu_estat"}{...}
{viewerjumpto "Description" "dsge estat covariance##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsge estat covariance##linkspdf"}{...}
{viewerjumpto "Options" "dsge estat covariance##options"}{...}
{viewerjumpto "Examples" "dsge estat covariance##examples"}{...}
{viewerjumpto "Stored results" "dsge estat covariance##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[DSGE] estat covariance} {hline 2}}Display estimated covariances of
model variables{p_end}
{p2col:}({mansection DSGE estatcovariance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:estat covariance}
[{varlist}]
[{cmd:,} {it:options}]

{phang}
{it:varlist} may include control variables and their lags.
If {it:varlist} is not specified, variances and covariances are reported
for all control variables in the model.

{synoptset 26}{...}
{synopthdr}
{synoptline}
{synopt :{opt addcov:ariance(clistc)}}report additional covariances{p_end}
{synopt :{opt nocov:ariance}}do not report covariances{p_end}
{synopt :{opt post}}post variances and covariances and their VCE as estimation results{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help dsge_estat_covariance##display_options:display_options}}}control columns and column formats and line width{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat covariance} displays model-implied covariances among control
variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE estatcovarianceQuickstart:Quick start}

        {mansection DSGE estatcovarianceRemarksandexamples:Remarks and examples}

        {mansection DSGE estatcovarianceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt addcovariance(clistc)} specifies that the covariances between the
control variables specified in {it:clistc} and those specified in
{it:varlist} be displayed.  The variances of variables in {it:clistc}
are not reported.  {it:clistc} can contain lags of the control
variables in the model.

{phang}
{cmd:nocovariance} specifies that no covariance be displayed.
{cmd:nocovariance} may not be specified with {cmd:addcovariance()}.

{phang}
{cmd:post} causes {cmd:estat covariance} to behave like a Stata estimation
(e-class) command.  {cmd:estat covariance} posts the estimated
variance-covariance matrix to {cmd:e()}, so you can treat it just as you
would results from any other estimation command.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2, clear}{p_end}
{phang2}{cmd:. constraint 1 _b[theta]=5}{p_end}
{phang2}{cmd:. constraint 2 _b[beta]=0.96}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsgenl (1 = {beta}*(x/F.x)*(1/z)*(r/F.p))}
        {cmd:({theta}-1 + {phi}*(p -1)*p = {theta}*x + {phi}*{beta}*(F.p-1)*F.p)}
        {cmd:(({beta})*r = (p)^({psi=2})*m)}
        {cmd:(ln(F.m) = {rhom}*ln(m))}
        {cmd:(ln(F.z) = {rhoz}*ln(z)),}
        {cmd:exostate(z m) unobserved(x) observed(p r)}
        {cmd:constraint(1 2)}{p_end}

{pstd}Model-implied covariance matrix{p_end}
{phang2}{cmd:. estat covariance}{p_end}

{pstd}Variance and first-order autocovariance of {cmd:x}{p_end}
{phang2}{cmd:. estat covariance x, addcovariance(L.x)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat covariance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}

{pstd}
If {cmd:post} is specified, {cmd:estat covariance} also stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
