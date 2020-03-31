{smcl}
{* *! version 1.0.5  30oct2018}{...}
{viewerdialog estat "dialog gsem_estat, message(-sd-) name(gsem_estat_sd)"}{...}
{vieweralsosee "[SEM] estat sd" "mansection SEM estatsd"}{...}
{findalias asgsemtfmm}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_sd##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_sd##menu"}{...}
{viewerjumpto "Description" "sem_estat_sd##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_sd##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_sd##options"}{...}
{viewerjumpto "Remarks" "sem_estat_sd##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_sd##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_sd##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[SEM] estat sd} {hline 2}}Display variance components as
standard deviations and correlations{p_end}
{p2col:}({mansection SEM estatsd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:sd}
[{cmd:,}
{cmd:verbose}
{cmd:post}
{cmdab:coefl:egend}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Other > Display standard deviations and correlations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat} {cmd:sd} is for use after {cmd:gsem} but not {cmd:sem}.

{pstd}
{cmd:estat sd} displays the fitted variance components as standard
deviations and correlations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatsdRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt verbose} specifies that the full estimation table be displayed.
By default, only the variance components are displayed.
This option is implied when {opt post} is specified.

{phang}
{opt post} causes {opt estat sd} to behave like a Stata estimation (e-class)
command.  {opt estat sd} posts the vector of calculated standard deviation and
correlation parameters along with the corresponding variance-covariance matrix
to {opt e()}, so that you can treat the estimated parameters just as you
would results from any other estimation command.  For example, you could use
{opt test} to perform simultaneous tests of hypotheses on the parameters,
or you could use {opt lincom} to create linear combinations.

{pstd}
The following option is not shown in the dialog box:

{phang}
{opt coeflegend} specifies that the legend of the coefficients and how to
              specify them in an expression be displayed rather than
              displaying the statistics for the coefficients.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias gsemtfmm}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit) (MathAtt -> att1-att5, ologit)}

{pstd}Fitted variance components as standard deviations and
correlations{p_end}
{phang2}{cmd:. estat sd}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat sd} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}coefficient vector{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:r(table)}}table of results{p_end}

{pstd}
If {cmd:post} is specified, {cmd:estat sd} stores the following in {cmd:e()}:

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{p2colreset}{...}
