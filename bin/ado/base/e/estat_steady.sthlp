{smcl}
{* *! version 1.0.0  25feb2019}{...}
{viewerdialog estat "dialog dsge_estat, message(-steady-) name(dsge_estat_steady)"}{...}
{vieweralsosee "[DSGE] estat steady" "mansection DSGE estatsteady"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 3f" "mansection DSGE Intro3f"}{...}
{viewerjumpto "Syntax" "estat steady##syntax"}{...}
{viewerjumpto "Menu for estat" "estat steady##menu_estat"}{...}
{viewerjumpto "Description" "estat steady##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_steady##linkspdf"}{...}
{viewerjumpto "Options" "estat steady##options"}{...}
{viewerjumpto "Examples" "estat steady##examples"}{...}
{viewerjumpto "Stored results" "estat steady##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[DSGE] estat steady} {hline 2}}Display steady state of nonlinear
DSGE model{p_end}
{p2col:}({mansection DSGE estatsteady:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:estat steady}
[{cmd:,} {cmd:compact}
{opt l:evel(#)}
{it:{help estat_steady##display_options:display_options}}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat steady} displays the estimated steady-state values of 
variables in a nonlinear DSGE model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE estatsteadyQuickstart:Quick start}

        {mansection DSGE estatsteadyRemarksandexamples:Remarks and examples}

        {mansection DSGE estatsteadyMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt compact} reports only the coefficient values of the estimated
steady-state vector.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opth cformat(fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2}{p_end}
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

{pstd}Obtain the steady state{p_end}
{phang2}{cmd:. estat steady}

{pstd}Report steady-state coefficients only{p_end}
{phang2}{cmd:. estat steady, compact}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat steady} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(steady)}}estimated steady-state vector{p_end}
{p2colreset}{...}
