{smcl}
{* *! version 1.0.5  03dec2019}{...}
{viewerdialog estat "dialog gsem_estat, message(-lcgof-) name(gsem_estat_lcgof)"}{...}
{vieweralsosee "[SEM] estat lcgof" "mansection SEM estatlcgof"}{...}
{findalias asgsemlcagof}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat ic" "help estat_ic"}{...}
{viewerjumpto "Syntax" "sem_estat_lcgof##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_lcgof##menu"}{...}
{viewerjumpto "Description" "sem_estat_lcgof##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_lcgof##linkspdf"}{...}
{viewerjumpto "Option" "sem_estat_lcgof##option"}{...}
{viewerjumpto "Remarks" "sem_estat_lcgof##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_lcgof##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_lcgof##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[SEM] estat lcgof} {hline 2}}Latent class goodness-of-fit
statistics{p_end}
{p2col:}({mansection SEM estatlcgof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:lcgof} [{cmd:,} {cmdab:nodes:cribe}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > LCA (latent class analysis) > Goodness of fit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat lcgof} is for use after {cmd:gsem} but not {cmd:sem}.

{pstd}
{cmd:estat lcgof} displays a variety of overall goodness-of-fit statistics
for latent class models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatlcgofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt nodescribe} suppresses the descriptions of the goodness-of-fit 
        measures. 


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias gsemlcagof}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lca1}{p_end}
{phang2}{cmd:. gsem (accident play insurance stock <- ), logit}{break}
	{cmd:lclass(C 2)}{p_end}

{pstd}Latent class goodness-of-fit statistic{p_end}
{phang2}{cmd:. estat lcgof}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat lcgof} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(chi2_ms)}}test of target model against saturated model{p_end}
{synopt:{cmd:r(df_ms)}}degrees of freedom for {cmd:r(chi2_ms)}{p_end}
{synopt:{cmd:r(p_ms)}}p-value for {cmd:r(chi2_ms)}{p_end}
{synopt:{cmd:r(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:r(bic)}}Bayesian information criterion{p_end}
{p2colreset}{...}
