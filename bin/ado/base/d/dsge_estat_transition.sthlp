{smcl}
{* *! version 1.0.5  25feb2019}{...}
{viewerdialog estat "dialog dsge_estat, message(-transition-) name(dsge_estat_transition)"}{...}
{vieweralsosee "[DSGE] estat transition" "mansection DSGE estattransition"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge" "help dsge"}{...}
{vieweralsosee "[DSGE] dsge postestimation" "help dsge postestimation"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 1" "mansection DSGE Intro1"}{...}
{viewerjumpto "Syntax" "dsge estat transition##syntax"}{...}
{viewerjumpto "Menu for estat" "dsge estat transition##menu_estat"}{...}
{viewerjumpto "Description" "dsge estat transition##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsge_estat_transition##linkspdf"}{...}
{viewerjumpto "Options" "dsge estat transition##options"}{...}
{viewerjumpto "Examples" "dsge estat transition##examples"}{...}
{viewerjumpto "Stored results" "dsge estat transition##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[DSGE] estat transition} {hline 2}}Display state transition
matrix{p_end}
{p2col:}({mansection DSGE estattransition:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:estat} {cmd:transition}
[{cmd:,}
{opt compact}
{opt post}
{opt l:evel(#)}
{help dsge_estat_transition##display_options:{it:display_options}}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat transition} displays the estimated state transition matrix
of the state-space form of a DSGE model. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE estattransitionQuickstart:Quick start}

        {mansection DSGE estattransitionRemarksandexamples:Remarks and examples}

        {mansection DSGE estattransitionMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt compact}
reports only the coefficient values of the estimated policy
matrix and displays these coefficients in matrix form.

{phang}
{opt post} causes {opt estat transition} to behave like a Stata
estimation (e-class) command. {opt estat transition} posts the
state transition matrix to {opt e()}, so you can treat it as you would
results from any other estimation command.

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
{phang2}{cmd:. webuse rates2}{p_end}
{phang2}{cmd:. generate p = 400*(ln(gdpdef) - ln(L.gdpdef))}{p_end}
{phang2}{cmd:. label variable p "Inflation rate"}{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*F.p + {c -(}kappa{c )-}*x)}
         {cmd:(x = F.x -(r - F.p - g), unobserved)}
         {cmd:(r = (1/{c -(}beta{c )-})*p + u)}
         {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
         {cmd:(F.g = {c -(}rhoz{c )-}*g, state)}

{pstd}Obtain the transition matrix{p_end}
{phang2}{cmd:. estat transition}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2, clear}{p_end}
{phang2}{cmd:. constraint 1 _b[beta]=0.96}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*F.p + {c -(}kappa{c )-}*x)}
        {cmd:(x = F.x -(r - F.p - g), unobserved)}
        {cmd:(r = {c -(}psi{c )-}*p + u)}
        {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
        {cmd:(F.g = {c -(}rhog{c )-}*g, state),}
        {cmd:from(psi=1.5) constraint(1)}{p_end}

{pstd}Obtain the transition matrix{p_end}
{phang2}{cmd:. estat transition}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat transition} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(transition)}}estimated transition matrix{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}

{pstd}
If {cmd:post} is specified, {cmd:estat transition} also stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(transition)}}estimated transition matrix{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
