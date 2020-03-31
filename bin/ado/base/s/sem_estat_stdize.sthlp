{smcl}
{* *! version 1.0.7  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-stdize-) name(sem_estat_stdize)"}{...}
{vieweralsosee "[SEM] estat stdize" "mansection SEM estatstdize"}{...}
{findalias assemcorr}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] lincom" "help sem_lincom"}{...}
{vieweralsosee "[SEM] nlcom" "help sem_nlcom"}{...}
{vieweralsosee "[SEM] test" "help sem_test"}{...}
{vieweralsosee "[SEM] testnl" "help sem_testnl"}{...}
{viewerjumpto "Syntax" "sem_estat_stdize##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_stdize##menu"}{...}
{viewerjumpto "Description" "sem_estat_stdize##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_stdize##linkspdf"}{...}
{viewerjumpto "Remarks" "sem_estat_stdize##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_stdize##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_stdize##results"}{...}
{p2colset 1 23 27 2}{...}
{p2col:{bf:[SEM] estat stdize} {hline 2}}Test standardized parameters{p_end}
{p2col:}({mansection SEM estatstdize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:std:ize}{cmd::} {cmd:test ...} 

{p 8 14 2}
{cmd:estat} {cmdab:std:ize}{cmd::} {cmd:lincom ...} 

{p 8 14 2}
{cmd:estat} {cmdab:std:ize}{cmd::} {cmd:testnl ...} 

{p 8 14 2}
{cmd:estat} {cmdab:std:ize}{cmd::} {cmd:nlcom ...} 


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Testing and CIs > Testing standardized parameters}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat stdize:} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd:estat stdize:} can be used to prefix {cmd:test}, {cmd:lincom}, 
{cmd:testnl}, and {cmd:nlcom}; see {helpb sem_test:[SEM] test}, 
{helpb sem_lincom:[SEM] lincom}, {helpb sem_testnl:[SEM] testnl}, and 
{helpb sem_nlcom:[SEM] nlcom}.

{pstd}
These commands without a prefix work in the underlying metric of SEM,
which is to say path coefficients, variances, and covariances.  If the
commands are prefixed with {cmd:estat stdize:}, they will work in the metric
of standardized coefficients and correlation coefficients.  There is no
counterpart to variances in the standardized metric because variances are
standardized to be 1.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatstdizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semhcfa}.

{pstd}
Exercise caution when using the {cmd:estat stdize:} prefix to perform tests on
estimated second moments (correlations).  Do not test that
correlations are 0.  Instead, omit the {cmd:estat stdize:} prefix and test
that covariances are 0.  Covariances are more likely to be normally
distributed than are correlations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse census13}{p_end}
{phang2}{cmd:. sem ( <- mrgrate dvcrate medage)}{p_end}

{pstd}Display correlations{p_end}
{phang2}{cmd:. sem ( <- mrgrate dvcrate medage), standardized}{p_end}

{pstd}Show coefficient legend{p_end}
{phang2}{cmd:. sem, coeflegend}{p_end}

{pstd}Test if correlations between median age and marriage rate and
between median age and divorce rate are equal{p_end}
{phang2}{cmd:. estat stdize: test _b[/cov(medage,mrgrate)]}{break}
	{cmd: = _b[/cov(medage,dvcrate)]}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
Stored results are the results stored by the command being used with the
{cmd:estat stdize:} prefix.
