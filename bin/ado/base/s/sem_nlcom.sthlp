{smcl}
{* *! version 1.0.7  19oct2017}{...}
{viewerdialog nlcom "dialog nlcom"}{...}
{vieweralsosee "[SEM] nlcom " "mansection SEM nlcom"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat stdize" "help sem_estat_stdize"}{...}
{findalias asgsemmediation}{...}
{vieweralsosee "[SEM] lincom" "help sem_lincom"}{...}
{vieweralsosee "[SEM] test" "help sem_test"}{...}
{vieweralsosee "[SEM] testnl" "help sem_testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{viewerjumpto "Syntax" "sem_nlcom##syntax"}{...}
{viewerjumpto "Menu" "sem_nlcom##menu"}{...}
{viewerjumpto "Description" "sem_nlcom##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_nlcom##linkspdf"}{...}
{viewerjumpto "Options" "sem_nlcom##options"}{...}
{viewerjumpto "Remarks" "sem_nlcom##remarks"}{...}
{viewerjumpto "Examples" "sem_nlcom##examples"}{...}
{viewerjumpto "Stored results" "sem_nlcom##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[SEM] nlcom} {hline 2}}Nonlinear combinations of parameters{p_end}
{p2col:}({mansection SEM nlcom:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}{cmd:nlcom} {it:{help exp:exp}} [{cmd:,}
      {it:{help nlcom:options}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Nonlinear combinations of parameters}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nlcom} is a postestimation command for use after {cmd:sem}, {cmd:gsem},
and other Stata estimation commands.

{pstd}
{cmd:nlcom} computes point estimates, standard errors, z statistics, p-values,
and confidence intervals for (possibly) nonlinear combinations of the
estimated parameters.  See {helpb nlcom:[R] nlcom}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM nlcomRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}    
See {it:{help nlcom##options:Options}} in {helpb nlcom:[R] nlcom}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias gsemmediation}.

{pstd}    
{cmd:nlcom} works in the metric of SEM, which is to say path coefficients,
variances, and covariances.  If you want to frame your nonlinear combinations
in terms of standardized coefficients and correlations and you fit the
model with {cmd:sem}, not {cmd:gsem}, then prefix {cmd:nlcom}
with {cmd:estat stdize:}; see {helpb sem_estat_stdize:[SEM] estat stdize}.

{pstd}    
{cmd:estat stdize:} is, strictly speaking, unnecessary because everywhere you
wanted a standardized coefficient or correlation, you could just type the
formula.  If you did that, you would get the same results except for numerical
precision.  The answer produced with the 
{cmd:estat stdize:} prefix will be a little more accurate because 
{cmd:estat stdize:} is able to substitute an analytic derivative in one part of
the calculation where {cmd:nlcom}, doing the whole thing itself, would be
forced to use a numeric derivative. 


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Show coefficient legend{p_end}
{phang2}{cmd:. sem, coeflegend}{p_end}

{pstd}Estimate the ratio of the coefficients for {cmd:a2} and {cmd:a3}{p_end}
{phang2}{cmd:. nlcom _b[a2:Affective] / _b[a3:Affective]}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_multmed}{p_end}
{phang2}{cmd:. gsem (perform <- satis support M1[branch])}{break}
	{cmd:(satis <- support M2[branch]), cov(M1[branch]*M2[branch]@0)}{p_end}

{pstd}Show coefficient legend{p_end}
{phang2}{cmd:. gsem, coeflegend}{p_end}

{pstd}Estimate the product of coefficients to obtain the indirect effect of 
{cmd:support} on {cmd:perform}{p_end}
{phang2}{cmd:. nlcom _b[perform:satis]*_b[satis:support]}{p_end}

    {hline}

{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help nlcom##results:Stored results}} in
{helpb nlcom:[R] nlcom}.
{p_end}
