{smcl}
{* *! version 1.0.9  20apr2018}{...}
{viewerdialog estat "dialog fmm_estat"}{...}
{vieweralsosee "[FMM] estat lcmean" "mansection FMM estatlcmean"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm_postestimation"}{...}
{viewerjumpto "Syntax" "fmm_estat_lcmean##syntax"}{...}
{viewerjumpto "Menu" "fmm_estat_lcmean##menu_estat"}{...}
{viewerjumpto "Description" "fmm_estat_lcmean##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_estat_lcmean##linkspdf"}{...}
{viewerjumpto "Options" "fmm_estat_lcmean##options"}{...}
{viewerjumpto "Remarks and examples" "fmm_estat_lcmean##remarks"}{...}
{viewerjumpto "Examples" "fmm_estat_lcmean##examples"}{...}
{viewerjumpto "Stored results" "fmm_estat_lcmean##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[FMM] estat lcmean} {hline 2}}Latent class marginal means{p_end}
{p2col:}({mansection FMM estatlcmean:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:lcmean} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt nose}}do not estimate SEs{p_end}
{synopt :{opt post}}post margins and their VCE as estimation results{p_end}
{synopt :{help fmm_estat_lcmean##display_options:{it:display_options}}}control
column formats, row spacing, and line width{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat lcmean} reports a table of the marginal predicted means of
the outcome within each latent class. For {opt ivregress}, {opt mlogit},
{opt oprobit}, and {opt ologit}, a table is produced for each outcome.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM estatlcmeanRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt nose} suppresses calculation of the VCE and standard errors.

{phang}
{opt post} causes {cmd:estat} {cmd:lcmean} to behave like a Stata estimation
(e-class) command.  {cmd:estat} {cmd:lcmean} posts the vector of estimated
margins along with the estimated variance-covariance matrix to {cmd:e()}, so
you can treat the estimated margins just as you would results from any other
estimation command.

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
{opt estat lcmean} is illustrated in
{findalias fmmexpoisson} and {findalias fmmexzip}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}

{pstd}Mixture of two logistic regression models{p_end}
{phang2}{cmd:. fmm 2: logit epay age i.male}

{pstd}Estimated marginal probability of {cmd:epay} within each latent class
{p_end}
{phang2}{cmd:. estat lcmean}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_mixture}

{pstd}Mixture of two Poisson regression models{p_end}
{phang2}{cmd:. fmm 2: poisson drvisits private medicaid c.age##c.age actlim chronic}

{pstd}Estimated marginal number of {cmd:drvisits} within each latent class
{p_end}
{phang2}{cmd:. estat lcmean}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{opt estat lcmean} stores the following in {opt r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(title)}}title in output{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt :{cmd:r(b)}}estimates{p_end}
{synopt :{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt :{cmd:r(table)}}matrix containing the margins with their standard
	  errors, test statistics, p-values, and confidence intervals{p_end}

{pstd}
{opt estat lcmean} with the {opt post} option also stores the following
in {opt e()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:e(title)}}title in output{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}estimates{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{p2colreset}{...}
