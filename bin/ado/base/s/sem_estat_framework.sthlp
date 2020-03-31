{smcl}
{* *! version 1.0.9  14may2018}{...}
{viewerdialog estat "dialog sem_estat, message(-framework-) name(sem_estat_framework)"}{...}
{vieweralsosee "[SEM] estat framework " "mansection SEM estatframework"}{...}
{findalias assemframework}{...}
{vieweralsosee "[SEM] Intro 7" "mansection SEM Intro7"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_framework##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_framework##menu"}{...}
{viewerjumpto "Description" "sem_estat_framework##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_framework##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_framework##options"}{...}
{viewerjumpto "Remarks" "sem_estat_framework##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_framework##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_framework##results"}{...}
{viewerjumpto "Reference" "sem_estat_framework##reference"}{...}
{p2colset 1 26 24 2}{...}
{p2col:{bf:[SEM] estat framework} {hline 2}}Display estimation results in
modeling framework{p_end}
{p2col:}({mansection SEM estatframework:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:fra:mework} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt stand:ardized}}report standardized results{p_end}
{synopt:{opt com:pact}}display matrices in compact form{p_end}
{synopt:{opt fit:ted}}include fitted means, variances, and covariances{p_end}
{synopt:{opth for:mat(%fmt)}}display format to use{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Other > Report model framework}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat framework} is a postestimation command for use after {cmd:sem} but
not {cmd:gsem}.

{pstd}
{cmd:estat framework} displays the estimation results as a series of matrices
derived from the Bentler-Weeks form; see
{help sem_estat_framework##Bentler1980:Bentler and Weeks (1980)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatframeworkRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt standardized}
reports results in standardized form. 

{phang}{opt compact}
displays matrices in compact form.  Zero matrices are displayed as a
description.  Diagonal matrices are shown as a row vector. 

{phang}{opt fitted}
displays the fitted mean and covariance values.

{phang}{opth format(%fmt)}
specifies the display format to be used.  The default is {cmd:format(%9.0g)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semframework}.

{pstd}
If {cmd:sem}'s {opt nm1} option was specified when the model was fit, all
covariance matrices are calculated using N-1 in the denominator instead of N. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_mimic1}{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd: (SubjSES <- income occpres)}{p_end}

{pstd}Display modeling framework{p_end}
{phang2}{cmd:. estat framework}{p_end}

{pstd}Include fitted means, variances, and covariances{p_end}
{phang2}{cmd:. estat framework, fitted}{p_end}

{pstd}Report standardized results{p_end}
{phang2}{cmd:. estat framework, standardized}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat framework} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}
{synopt:{cmd:r(standardized)}}indicator for standardized results (+){p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{synopt:{cmd:r(Beta}[{cmd:_}{it:#}]{cmd:)}}coefficients of endogenous
variables on endogenous variables (for group {it:#}){p_end}
{synopt:{cmd:r(Gamma}[{cmd:_}{it:#}]{cmd:)}}coefficients of endogenous 
variables on exogenous variables (for group {it:#}){p_end}
{synopt:{cmd:r(alpha}[{cmd:_}{it:#}]{cmd:)}}intercepts (for group {it:#}) (*){p_end}
{synopt:{cmd:r(Psi}[{cmd:_}{it:#}]{cmd:)}}covariances of errors (for group
	{it:#}){p_end}
{synopt:{cmd:r(Phi}[{cmd:_}{it:#}]{cmd:)}}covariances of exogenous variables (for group {it:#}){p_end}
{synopt:{cmd:r(kappa}[{cmd:_}{it:#}]{cmd:)}}means of exogenous variables (for
group {it:#}) (*){p_end}
{synopt:{cmd:r(Sigma}[{cmd:_}{it:#}]{cmd:)}}fitted covariances (for group {it:#}){p_end}
{synopt:{cmd:r(mu}[{cmd:_}{it:#}]{cmd:)}}fitted means (for group {it:#}) (*){p_end}

{p 4 8 2}
(+) If {cmd:r(standardized)}=1, the returned matrices contain standardized
values. 

{p 4 8 2}
(*) If there are no estimated means or intercepts in the {cmd:sem} model,
these matrices are not returned.  
{p_end}


{marker reference}{...}
{title:Reference}

{marker Bentler1980}{...}
{phang}
Bentler, P. M., and D. G. Weeks. 1980.  Linear structural equations with latent
variables.  {it:Psychometrika} 45: 289-308.
{p_end}
