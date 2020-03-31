{smcl}
{* *! version 1.0.4  25feb2019}{...}
{viewerdialog estat "dialog dsge_estat, message(-stable-) name(dsge_estat_stable)"}{...}
{vieweralsosee "[DSGE] estat stable" "mansection DSGE estatstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge" "help dsge"}{...}
{vieweralsosee "[DSGE] dsge postestimation" "help dsge postestimation"}{...}
{vieweralsosee "[DSGE] dsgenl" "help dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 5" "mansection DSGE Intro5"}{...}
{viewerjumpto "Syntax" "dsge estat stable##syntax"}{...}
{viewerjumpto "Menu for estat" "dsge estat stable##menu_estat"}{...}
{viewerjumpto "Description" "dsge estat stable##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsge_estat_stable##linkspdf"}{...}
{viewerjumpto "Examples" "dsge estat stable##examples"}{...}
{viewerjumpto "Stored results" "dsge estat stable##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[DSGE] estat stable} {hline 2}}Check stability of system{p_end}
{p2col:}({mansection DSGE estatstable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:estat stable}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat stable} displays functions of the model parameters that indicate
whether the model is saddle-path stable at specific parameter values.
These results can help you find initial values for which the model is
saddle-path stable.  Saddle-path stability is required for solving and 
estimating the parameters of DSGE models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE estatstableRemarksandexamples:Remarks and examples}

        {mansection DSGE estatstableMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsge (p = (1/{c -(}gamma{c )-})*F.p + {c -(}kappa{c )-}*y)}
          {cmd:(y = F.y -(r - F.p - z), unobserved)}
          {cmd:(r = {c -(}gamma{c )-}*p + u)}
          {cmd:(F.u = {c -(}rho_u{c )-}*u, state)}
          {cmd:(F.z = {c -(}rho_z1{c )-}*z + {c -(}rho_z2{c )-}*Lz, state)}
          {cmd:(F.Lz = z, state noshock), solve noidencheck}

{pstd}Obtain eigenvalues implied by the initial values{p_end}
{phang2}{cmd:. estat stable}

{pstd}Repeat the parameter estimation but specify 1.2 as an initial value
for {cmd:gamma}{p_end}
{phang2}{cmd:. dsge (p = (1/{c -(}gamma{c )-})*F.p + {c -(}kappa{c )-}*y)}
     {cmd:(y = F.y -(r - F.p - z), unobserved)}
     {cmd:(r = {c -(}gamma{c )-}*p + u)}
     {cmd:(F.u = {c -(}rho_u{c )-}*u, state)}
     {cmd:(F.z = {c -(}rho_z1{c )-}*z + {c -(}rho_z2{c )-}*Lz, state)}
     {cmd:(F.Lz = z, state noshock),}
     {cmd:solve noidencheck from(gamma=1.2)}

{pstd}Obtain eigenvalues implied by the initial values{p_end}
{phang2}{cmd:. estat stable}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat stable} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(stable)}}{cmd:1} if stable, {cmd:0} otherwise{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(eigenvalues)}}eigenvalues{p_end}
{p2colreset}{...}
