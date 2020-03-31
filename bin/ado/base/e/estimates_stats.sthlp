{smcl}
{* *! version 2.1.11  31oct2018}{...}
{viewerdialog "estimates stats" "dialog estimates_stats"}{...}
{vieweralsosee "[R] estimates stats" "mansection R estimatesstats"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_stats##syntax"}{...}
{viewerjumpto "Menu" "estimates_stats##menu"}{...}
{viewerjumpto "Description" "estimates_stats##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_stats##linkspdf"}{...}
{viewerjumpto "Options" "estimates_stats##options"}{...}
{viewerjumpto "Examples" "estimates_stats##examples"}{...}
{viewerjumpto "Stored results" "estimates_stats##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estimates stats} {hline 2}}Model-selection statistics{p_end}
{p2col:}({mansection R estimatesstats:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt stat:s} 
[{it:namelist}]
[{cmd:,}
{cmd:n(}{it:#}{cmd:)} {opt bicdetail}]

{phang}
where {it:namelist} is a name, a list of names, {cmd:_all}, or 
{cmd:*}.{break}
A name may be {cmd:.}, meaning the current (active) estimates.{break}
{cmd:_all} and {cmd:*} mean the same thing.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:stats} reports model-selection statistics, including the
Akaike information criterion (AIC) and the Bayesian information criterion
(BIC).  These measures are appropriate for maximum likelihood models.

{pstd}
If {cmd:estimates} {cmd:stats} is used for a non-likelihood-based model,
such as {cmd:qreg}, missing values are reported.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesstatsQuickstart:Quick start}

        {mansection R estimatesstatsRemarksandexamples:Remarks and examples}

        {mansection R estimatesstatsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:n(}{it:#}{cmd:)} specifies the {it:N} to be used in calculating the
    BIC; see {bf:{help bic_note:[R] BIC note}}.

{phang}
{opt bicdetail} produces a table showing the type of N used in the BIC
calculation.  Most estimation commands use the number of observations in the
estimation sample for the BIC.  For some models, however, other types of N,
such as the number of cases in choice models, should be used for the BIC.
When the default table of {cmd:estimates} {cmd:stats} contains more than one
type of N, specifying {cmd:bicdetail} allows you to see the different types
of N used for the BIC.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. logistic foreign mpg weight displ}

{pstd}Create a table for the most recent estimation results{p_end}
{phang2}{cmd:. estimates stats}

{pstd}Compare two models{p_end}
{phang2}{cmd:. logistic foreign mpg weight displ}{p_end}
{phang2}{cmd:. estimates store full}{p_end}
{phang2}{cmd:. logistic foreign mpg weight}{p_end}
{phang2}{cmd:. estimates store sub}{p_end}
{phang2}{cmd:. estimates stats full sub}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates} {cmd:stats} stores the following in {cmd:r()}:

	Matrices
{p2col 12 23 25 2:  {cmd:r(S)}}matrix with 6 columns (N, ll0, ll, df, AIC, and
                            BIC) and rows corresponding to models in table
{p_end}
