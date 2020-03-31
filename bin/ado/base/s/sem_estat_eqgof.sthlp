{smcl}
{* *! version 1.0.9  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-eqgof-) name(sem_estat_eqgof)"}{...}
{vieweralsosee "[SEM] estat eqgof" "mansection SEM estateqgof"}{...}
{findalias assemtfmm}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat ggof" "help sem_estat_ggof"}{...}
{vieweralsosee "[SEM] estat gof" "help sem_estat_gof"}{...}
{viewerjumpto "Syntax" "sem_estat_eqgof##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_eqgof##menu"}{...}
{viewerjumpto "Description" "sem_estat_eqgof##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_eqgof##linkspdf"}{...}
{viewerjumpto "Option" "sem_estat_eqgof##option"}{...}
{viewerjumpto "Remarks" "sem_estat_eqgof##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_eqgof##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_eqgof##results"}{...}
{viewerjumpto "Reference" "sem_estat_eqgof##reference"}{...}
{p2colset 1 22 20 2}{...}
{p2col:{bf:[SEM] estat eqgof} {hline 2}}Equation-level
	goodness-of-fit statistics{p_end}
{p2col:}({mansection SEM estateqgof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:eqg:of} [{cmd:,} {opth for:mat(%fmt)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Goodness of fit > Equation-level goodness of fit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat eqgof} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd: estat eqgof} displays equation-by-equation goodness-of-fit statistics.
Displayed are R-squared and the Bentler-Raykov squared multiple-correlation
coefficient ({help sem_estat_eqgof##Bentler2000:Bentler and Raykov 2000}).

{pstd}
These two concepts of fit are equivalent for recursive SEMs and univariate
linear regression.  For nonrecursive SEMs, these measures are distinct.

{pstd}
Equation-level variance decomposition is also reported, along with the overall
model coefficient of determination.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estateqgofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}{opth format(%fmt)} specifies the display format.  The default is
{cmd:format(%9.0g)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semtfmm}.

{pstd}
In rare circumstances, these equation-level goodness-of-fit measures in
nonrecursive structural equations have unexpected values.  It is possible to
obtain negative R-squared and multiple-correlation values.

{pstd}
It is recommended to use the Bentler-Raykov squared multiple correlations as a
measure of explained variance for nonrecursive systems that involve endogenous
variables with reciprocal causations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Display equation-level goodness-of-fit statistics{p_end}
{phang2}{cmd:. estat eqgof}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat eqgof} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}
{synopt:{cmd:r(CD}[{cmd:_}{it:#}]{cmd:)}}overall coefficient of determination
	(for group {it:#}){p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(eqfit}[{cmd:_}{it:#}]{cmd:)}}fit statistics (for group
{it:#}){p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker Bentler2000}{...}
{phang}
Bentler, P. M., and T. Raykov. 2000.  On measures of explained variance in
nonrecursive structural equation models.  {it:Journal of Applied Psychology}
85: 125-131.
{p_end}
