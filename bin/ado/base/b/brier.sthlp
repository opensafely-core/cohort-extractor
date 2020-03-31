{smcl}
{* *! version 1.1.9  13apr2018}{...}
{viewerdialog brier "dialog brier"}{...}
{vieweralsosee "[R] brier" "mansection R brier"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{viewerjumpto "Syntax" "brier##syntax"}{...}
{viewerjumpto "Menu" "brier##menu"}{...}
{viewerjumpto "Description" "brier##description"}{...}
{viewerjumpto "Links to PDF documentation" "brier##linkspdf"}{...}
{viewerjumpto "Option" "brier##option"}{...}
{viewerjumpto "Example" "brier##example"}{...}
{viewerjumpto "Stored results" "brier##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] brier} {hline 2}}Brier score decomposition{p_end}
{p2col:}({mansection R brier:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:brier} {it:outcomevar} {it:forecastvar} {ifin} 
[{cmd:,} {opt g:roup(#)}]

{phang}
{it:outcomevar} is a binary variable indicating the outcome of the experiment.

{phang}
{it:forecastvar} is the corresponding probability of a positive outcome and
must be between 0 and 1.

{phang}
{cmd:by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Other > Brier score decomposition}


{marker description}{...}
{title:Description}

{pstd}
{cmd:brier} computes the Yates, Sanders, and Murphy decompositions of the
Brier mean probability score.  The Brier score is a measure of disagreement
between the observed outcome and a forecast (prediction).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R brierQuickstart:Quick start}

        {mansection R brierRemarksandexamples:Remarks and examples}

        {mansection R brierMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Main}

{phang}
{opt group(#)} specifies the number of groups that will be used to compute the
decomposition.  {cmd:group(10)} is the default.


{marker example}{...}
{title:Example}

{phang}{cmd:. webuse bball}{p_end}
{phang}{cmd:. brier win for, group(5)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:brier} stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(p_roc)}}one-sided p-value for ROC-area test{p_end}
{synopt:{cmd:r(roc_area)}}ROC area{p_end}
{synopt:{cmd:r(z)}}Spiegelhalter's z statistic{p_end}
{synopt:{cmd:r(p)}}one-sided p-value for Spiegelhalter's z test{p_end}
{synopt:{cmd:r(brier)}}Brier score{p_end}
{synopt:{cmd:r(brier_s)}}Sanders-modified Brier score{p_end}
{synopt:{cmd:r(sanders)}}Sanders resolution{p_end}
{synopt:{cmd:r(oiv)}}outcome index variance{p_end}
{synopt:{cmd:r(murphy)}}Murphy resolution{p_end}
{synopt:{cmd:r(relinsm)}}reliability-in-the-small{p_end}
{synopt:{cmd:r(Var_f)}}forecast variance{p_end}
{synopt:{cmd:r(Var_fex)}}excess forecast variance{p_end}
{synopt:{cmd:r(Var_fmin)}}minimum forecast variance{p_end}
{synopt:{cmd:r(relinla)}}reliability-in-the-large{p_end}
{synopt:{cmd:r(cov_2f)}}2*forecast-outcome-covariance{p_end}
{p2colreset}{...}
