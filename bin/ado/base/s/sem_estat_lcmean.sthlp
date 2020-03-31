{smcl}
{* *! version 1.0.4  04oct2018}{...}
{viewerdialog estat "dialog gsem_estat, message(-lcmean-) name(gsem_estat_lcmean)"}{...}
{vieweralsosee "[SEM] estat lcmean" "mansection SEM estatlcmean"}{...}
{findalias asgsemlca}{...}
{findalias asgsempfmm}{...}
{findalias asgsempfmmtwo}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_lcmean##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_lcmean##menu"}{...}
{viewerjumpto "Description" "sem_estat_lcmean##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_lcmean##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_lcmean##options"}{...}
{viewerjumpto "Remarks" "sem_estat_lcmean##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_lcmean##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_lcmean##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SEM] estat lcmean} {hline 2}}Latent class marginal means{p_end}
{p2col:}({mansection SEM estatlcmean:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:lcmean} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:nose}}do not estimate SEs{p_end}
{synopt:{cmd:post}}post margins and their VCE as estimation results{p_end}
{synopt:{it:{help sem_estat_lcmean##display_options:display_options}}}control column formats, row spacing, and line width{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > LCA (latent class analysis) > Class marginal means}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat lcmean} is for use after {cmd:gsem} but not {cmd:sem}.

{pstd}
{cmd:estat lcmean} reports a table of the marginal predicted means of
each outcome within each latent class.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatlcmeanRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt nose}
suppresses calculation of the VCE and standard errors.

{phang}
{opt post} 
causes {opt estat lcmean} to behave like a Stata estimation (e-class) command.
{opt estat lcmean} posts the vector of estimated margins along with the
estimated variance-covariance matrix to {opt e()}, so you can treat the
estimated margins just as you would results from any other estimation
command.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See
{findalias gsemlca},
{findalias gsempfmm}, and
{findalias gsempfmmtwo}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lca1}{p_end}
{phang2}{cmd:. gsem (accident play insurance stock <- ), logit}{break}
	{cmd:lclass(C 2)}{p_end}

{pstd}Latent class marginal means{p_end}
{phang2}{cmd:. estat lcmean}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat lcmean} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:r(title)}}title in output{p_end}

{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt:{cmd:r(table)}}matrix containing the margins with their standard
	  errors, test statistics, p-values, and confidence intervals{p_end}
{p2colreset}{...}

{pstd}
{cmd:estat lcmean} with the {cmd:post} option also stores the following
in {cmd:e()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}

{p2col 5 18 22 2: Macros}{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
