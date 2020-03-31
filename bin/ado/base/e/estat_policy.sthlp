{smcl}
{* *! version 1.0.5  25feb2019}{...}
{viewerdialog estat "dialog dsge_estat, message(-policy-) name(dsge_estat_policy)"}{...}
{vieweralsosee "[DSGE] estat policy" "mansection DSGE estatpolicy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge" "help dsge"}{...}
{vieweralsosee "[DSGE] dsge postestimation" "help dsge postestimation"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 1" "mansection DSGE Intro1"}{...}
{viewerjumpto "Syntax" "estat policy##syntax"}{...}
{viewerjumpto "Menu for estat" "estat policy##menu_estat"}{...}
{viewerjumpto "Description" "estat policy##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_policy##linkspdf"}{...}
{viewerjumpto "Options" "estat policy##options"}{...}
{viewerjumpto "Examples" "estat policy##examples"}{...}
{viewerjumpto "Stored results" "estat policy##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[DSGE] estat policy} {hline 2}}Display policy matrix{p_end}
{p2col:}({mansection DSGE estatpolicy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:estat policy}
[{cmd:,}
{opt compact}
{opt post}
{opt l:evel(#)}
{help estat_policy##display_options:{it:display_options}}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat policy} displays the estimated policy matrix of the 
state-space form of a DSGE model. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE estatpolicyQuickstart:Quick start}

        {mansection DSGE estatpolicyRemarksandexamples:Remarks and examples}

        {mansection DSGE estatpolicyMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt compact} reports only the coefficient values of the estimated policy
matrix and displays these coefficients in matrix form.

{phang}
{opt post} causes {opt estat policy} to behave like a Stata estimation
(e-class) command.  {opt estat policy} posts the policy matrix parameters along
with the estimated variance-covariance matrix to {opt e()}, so you can treat
the estimated policy matrix as you would results from any other estimation
command.

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

{pstd}Obtain the policy matrix{p_end}
{phang2}{cmd:. estat policy}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2, clear}{p_end}
{phang2}{cmd:. constraint 1 _b[beta]=0.96}{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*F.p + {c -(}kappa{c )-}*x)}
               {cmd:(x = F.x -(r - F.p - g), unobserved)}
               {cmd:(r = {c -(}psi{c )-}*p + u)}
               {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
               {cmd:(F.g = {c -(}rhog{c )-}*g, state),}
               {cmd:from(psi=1.5) constraint(1)}

{pstd}Obtain the policy matrix{p_end}
{phang2}{cmd:. estat policy}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat policy} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(policy)}}estimated policy matrix{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}

{pstd}
If {cmd:post} is specified, {cmd:estat policy} also stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(policy)}}estimated policy matrix{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
