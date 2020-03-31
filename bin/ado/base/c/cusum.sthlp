{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog cusum "dialog cusum"}{...}
{vieweralsosee "[R] cusum" "mansection R cusum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{viewerjumpto "Syntax" "cusum##syntax"}{...}
{viewerjumpto "Menu" "cusum##menu"}{...}
{viewerjumpto "Description" "cusum##description"}{...}
{viewerjumpto "Links to PDF documentation" "cusum##linkspdf"}{...}
{viewerjumpto "Options" "cusum##options"}{...}
{viewerjumpto "Examples" "cusum##examples"}{...}
{viewerjumpto "Stored results" "cusum##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] cusum} {hline 2}}Cusum plots and tests for binary variables
{p_end}
{p2col:}({mansection R cusum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:cusum} {it:yvar} {it:xvar}
{ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opth gen:erate(newvar)}}save cumulative sum in {it:newvar}{p_end}
{synopt :{opt yf:it(fitvar)}}calculate cumulative sum against {it:fitvar}{p_end}
{synopt :{opt nog:raph}}suppress the plot{p_end}
{synopt :{opt noca:lc}}suppress cusum test statistics{p_end}

{syntab :Cusum plot}
{synopt :{it:{help connect_options}}}affect the rendition of the plotted line{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Other > Quality control >}
       {bf:Cusum plots and tests for binary variables}


{marker description}{...}
{title:Description}

{pstd}
{opt cusum} graphs the cumulative sum (cusum) of a binary (0/1) variable,
{it:yvar}, against a (usually) continuous variable, {it:xvar}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R cusumQuickstart:Quick start}

        {mansection R cusumRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth generate(newvar)} saves the cusum in {it:newvar}.

{phang}
{opt yfit(fitvar)} calculates a cusum against {it:fitvar},
that is, the running sums of the "residuals" {it:fitvar} minus
{it:yvar}.
Typically, {it:fitvar} is the predicted probability of a positive outcome
obtained from a logistic regression analysis.

{phang}
{opt nograph} suppresses the plot.

{phang}
{opt nocalc} suppresses calculation of the cusum test statistics.

{dlgtab:Cusum plot}

{phang}
{it:connect_options} affect the rendition of the plotted line; see
{manhelpi connect_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)}
provides a way to add other plots to the generated
graph.  See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.
These include options for titling the graph (see {manhelpi title_options G-3})
and for saving the graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Graph cumulative sum of {cmd:foreign} against {cmd:weight}{p_end}
{phang2}{cmd:. cusum foreign weight}{p_end}

{pstd}Save as above, but save the cumulative sum in variable {cmd:cs}{p_end}
{phang2}{cmd:. cusum foreign weight, generate(cs)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cusum} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(prop1)}}proportion of positive outcomes{p_end}
{synopt:{cmd:r(cusum1)}}cusum{p_end}
{synopt:{cmd:r(zl)}}test (linear){p_end}
{synopt:{cmd:r(P_zl)}}p-value for test (linear){p_end}
{synopt:{cmd:r(cusumq)}}quadratic cusum{p_end}
{synopt:{cmd:r(zq)}}test (quadratic){p_end}
{synopt:{cmd:r(P_zq)}}p-value for test (quadratic){p_end}
{p2colreset}{...}
