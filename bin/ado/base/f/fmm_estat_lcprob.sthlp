{smcl}
{* *! version 1.0.9  20apr2018}{...}
{viewerdialog estat "dialog fmm_estat"}{...}
{vieweralsosee "[FMM] estat lcprob" "mansection FMM estatlcprob"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm_postestimation"}{...}
{viewerjumpto "Syntax" "fmm_estat_lcprob##syntax"}{...}
{viewerjumpto "Menu" "fmm_estat_lcprob##menu_estat"}{...}
{viewerjumpto "Description" "fmm_estat_lcprob##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_estat_lcprob##linkspdf"}{...}
{viewerjumpto "Options" "fmm_estat_lcprob##options"}{...}
{viewerjumpto "Remarks and examples" "fmm_estat_lcprob##remarks"}{...}
{viewerjumpto "Examples" "fmm_estat_lcprob##examples"}{...}
{viewerjumpto "Stored results" "fmm_estat_lcprob##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[FMM] estat lcprob} {hline 2}}Latent class marginal
probabilities{p_end}
{p2col:}({mansection FMM estatlcprob:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:lcprob} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt classpr}}latent class probability; the default{p_end}
{synopt :{opt classpost:eriorpr}}posterior latent class probability{p_end}
{synopt :{opt nose}}do not estimate SEs{p_end}
{synopt :{opt post}}post margins and their VCE as estimation results{p_end}
{synopt :{help fmm_estat_lcprob##display_options:{it:display_options}}}control
column formats, row spacing, and line width{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat} {cmd:lcprob} reports a table of the marginal predicted latent
class probabilities.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM estatlcprobRemarksandexamples:Remarks and examples}

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
The posterior probabilities are a function of the latent-class predictors
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
{title:Remarks and examples}

{pstd}
{opt estat lcprob} is illustrated in
{findalias fmmexrega},
{findalias fmmexpoisson},
and
{findalias fmmexzip}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}

{pstd}Mixture of two complementary log-log regression models{p_end}
{phang2}{cmd:. fmm 2: cloglog epay age i.male}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmm_hsng2}

{pstd}Mixture of two regression models with endogenous covariate {cmd:hsngval}
{p_end}
{phang2}{cmd:. fmm 2: ivregress rent pcturban (hsngval = faminc)}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{opt estat lcprob} stores the following in {opt r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(title)}}title in output{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(b)}}estimates{p_end}
{synopt :{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt :{cmd:r(table)}}matrix containing the margins with their standard
	  errors, test statistics, p-values, and confidence intervals{p_end}

{pstd}
{opt estat lcprob} with the {opt post} option also stores the following
in {opt e()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(title)}}title in output{p_end}
{synopt :{cmd:e(classposteriorpr)}}{cmd:classposteriorpr} or empty{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}estimates{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
