{smcl}
{* *! version 1.0.7  19oct2017}{...}
{viewerdialog lincom "dialog lincom"}{...}
{vieweralsosee "[SEM] lincom " "mansection SEM lincom"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat stdize" "help sem_estat_stdize"}{...}
{vieweralsosee "[SEM] nlcom" "help sem_nlcom"}{...}
{vieweralsosee "[SEM] test" "help sem_test"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{viewerjumpto "Syntax" "sem_lincom##syntax"}{...}
{viewerjumpto "Menu" "sem_lincom##menu"}{...}
{viewerjumpto "Description" "sem_lincom##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_lincom##linkspdf"}{...}
{viewerjumpto "Options" "sem_lincom##options"}{...}
{viewerjumpto "Remarks" "sem_lincom##remarks"}{...}
{viewerjumpto "Examples" "sem_lincom##examples"}{...}
{viewerjumpto "Stored results" "sem_lincom##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[SEM] lincom} {hline 2}}Linear combinations of parameters{p_end}
{p2col:}({mansection SEM lincom:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}{cmd:lincom} {it:{help exp:exp}} [{cmd:,}
          {it:{help lincom:options}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Linear combinations of parameters}


{marker description}{...}
{title:Description}

{pstd}    
{cmd:lincom} is a postestimation command for use after {cmd:sem}, {cmd:gsem},
and nearly all Stata estimation commands.

{pstd}    
{cmd:lincom} computes point estimates, standard errors, z statistics,
p-values, and confidence intervals for linear combinations of the estimated
parameters. 

{pstd}
After {cmd:sem} and {cmd:gsem}, you must use the {cmd:_b[]} coefficient
notation; you cannot refer to variables by using shortcuts to obtain
coefficients on variables. 

{pstd}    
See {helpb lincom:[R] lincom}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM lincomRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}    
See {it:{help lincom##options:Options}} in {helpb lincom:[R] lincom}.


{marker remarks}{...}
{title:Remarks}

{pstd}    
{cmd:lincom} works in the metric of SEM, which is to say path coefficients,
variances, and covariances.  If you want to frame your linear combinations in
terms of standardized coefficients and correlations and you fit the model with
{cmd:sem}, not {cmd:gsem}, then prefix {cmd:lincom} with
{cmd:estat stdize:}; see {helpb sem_estat_stdize:[SEM] estat stdize}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Show coefficient legend{p_end}
{phang2}{cmd:. sem, coeflegend}{p_end}

{pstd}Estimate linear combination of coefficients{p_end}
{phang2}{cmd:. lincom _b[a1:Affective]*2 - _b[a2:Affective]}{p_end}
{phang2}{cmd:. lincom _b[a5:Affective] - _b[a4:Affective]}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help lincom##results:Stored results}} in
{helpb lincom:[R] lincom}.
