{smcl}
{* *! version 1.0.4  04oct2018}{...}
{viewerdialog estat "dialog gsem_estat, message(-lcprob-) name(gsem_estat_lcprob)"}{...}
{vieweralsosee "[SEM] estat lcprob" "mansection SEM estatlcprob"}{...}
{findalias asgsemlca}{...}
{findalias asgsempfmm}{...}
{findalias asgsempfmmtwo}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_lcprob##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_lcprob##menu"}{...}
{viewerjumpto "Description" "sem_estat_lcprob##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_lcprob##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_lcprob##options"}{...}
{viewerjumpto "Remarks" "sem_estat_lcprob##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_lcprob##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_lcprob##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SEM] estat lcprob} {hline 2}}Latent class marginal
probabilities{p_end}
{p2col:}({mansection SEM estatlcprob:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:lcprob} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt classpr}}latent class probability; the default{p_end}
{synopt:{opt classpost:eriorpr}}posterior latent class probability{p_end}

{synopt:{opt nose}}do not estimate SEs{p_end}
{synopt:{opt post}}post margins and their VCE as estimation results{p_end}
{synopt:{it:{help sem_estat_lcprob##display_options:display_options}}}control column formats, row spacing, and line width{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics >  LCA (latent class analysis) > Class marginal probabilities}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat} {cmd:lcprob} is for use after {cmd:gsem} but not {cmd:sem}.

{pstd}
{cmd:estat} {cmd:lcprob} reports a table of the marginal predicted latent
class probabilities.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatlcprobRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt classpr}, the default, calculates marginal predicted probabilities
for each latent class.

{phang}
{opt classposteriorpr} calculates marginal predicted posterior
probabilities for each latent class.
The posterior probabilities are a function of the latent class predictors
and the fitted outcome densities.

{phang}
{opt nose}
suppresses calculation of the VCE and standard errors.

{phang}
{opt post} 
causes {opt estat lcprob} to behave like a Stata estimation (e-class) command.
{opt estat lcprob} posts the vector of estimated margins along with the
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

{pstd}Latent class marginal probabilities{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat lcprob} stores the following in {cmd:r()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:r(title)}}title in output{p_end}
{synopt:{cmd:r(classposteriorpr)}}{cmd:classposteriorpr}{p_end}

{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt:{cmd:r(table)}}matrix containing the margins with their standard
	  errors, test statistics, p-values, and confidence intervals{p_end}
{p2colreset}{...}

{pstd}
{cmd:estat lcprob} with the {cmd:post} option also stores the following
in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}

{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(classposteriorpr)}}{cmd:classposteriorpr}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
