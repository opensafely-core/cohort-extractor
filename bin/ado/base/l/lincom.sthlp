{smcl}
{* *! version 1.3.6  14may2018}{...}
{viewerdialog lincom "dialog lincom"}{...}
{vieweralsosee "[R] lincom" "mansection R lincom"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy postestimation"}{...}
{viewerjumpto "Syntax" "lincom##syntax"}{...}
{viewerjumpto "Menu" "lincom##menu"}{...}
{viewerjumpto "Description" "lincom##description"}{...}
{viewerjumpto "Links to PDF documentation" "lincom##linkspdf"}{...}
{viewerjumpto "Options" "lincom##options"}{...}
{viewerjumpto "Examples" "lincom##examples"}{...}
{viewerjumpto "Stored results" "lincom##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] lincom} {hline 2}}Linear combinations of parameters{p_end}
{p2col:}({mansection R lincom:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:lincom} {it:{help exp}} [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt :{opt ef:orm}}generic label; {cmd:exp(b)}{p_end}
{synopt :{opt or}}odds ratio{p_end}
{synopt :{opt hr}}hazard ratio{p_end}
{synopt :{opt shr}}subhazard ratio{p_end}
{synopt :{opt ir:r}}incidence-rate ratio{p_end}
{synopt :{opt rr:r}}relative-risk ratio{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help lincom##display_options:display_options}}}control column
       formats{p_end}

{synopt :{opt df(#)}}use t distribution with {it:#} degrees of freedom for
       computing p-values and confidence intervals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:exp} is any linear combination of coefficients that is valid
syntax for {cmd:test}; see {helpb test:[R] test}.  {it:exp} must not contain
an equal sign.
{p_end}
{p 4 6 2}
{opt df(#)} does not appear in the dialog box.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lincom} computes point estimates, standard errors, t or z statistics,
p-values, and confidence intervals for linear combinations of coefficients
after any estimation command, including survey estimation.  Results can
optionally be displayed as odds ratios, hazard ratios, incidence-rate ratios,
or relative-risk ratios.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lincomQuickstart:Quick start}

        {mansection R lincomRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt eform}, {opt or}, {opt hr}, {opt shr},  {opt irr}, and {opt rrr} all report
coefficient estimates as exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  {opt or} is the default after
{cmd:logistic}.  The only difference in these options is how the output is
labeled.

	Option{col 19}Label{col 32}Explanation{col 56}Example commands
	{hline 63}
	{cmd:eform}{col 19}{cmd:exp(b)}{col 32}Generic label{col 56}{helpb cloglog}
	{cmd:or}{col 19}{cmd:Odds Ratio}{col 32}Odds ratio{col 56}{helpb logistic}, {helpb logit}
	{cmd:hr}{col 19}{cmd:Haz. Ratio}{col 32}Hazard ratio{col 56}{helpb stcox}, {helpb streg}
	{cmd:shr}{col 19}{cmd:SHR}{col 32}Subhazard ratio{col 56}{helpb stcrreg}
	{cmd:irr}{col 19}{cmd:IRR}{col 32}Incidence-rate ratio{col 56}{helpb poisson}
	{cmd:rrr}{col 19}{cmd:RRR}{col 32}Relative-rate ratio{col 56}{helpb mlogit}
	{hline 63}

{pmore}
{it:{help exp}} may not contain any additive constants when you use
the {opt eform}, {opt or}, {opt hr}, {opt irr}, or {opt rrr} option.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)}, and
{opt sformat(%fmt)};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following option is available with {opt lincom} but is not shown in the
dialog box:

{phang}
{opt df(#)} specifies that the t distribution with {it:#} degrees of
freedom be used for computing p-values and confidence intervals.
The default is to use {cmd:e(df_r)} degrees of freedom or the standard normal
distribution if {cmd:e(df_r)} is missing.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse regress}{p_end}
{phang2}{cmd:. regress y x1 x2 x3}{p_end}

{pstd}Estimate linear combinations of coefficients{p_end}
{phang2}{cmd:. lincom x2-x1}{p_end}
{phang2}{cmd:. lincom 3*x1 + 500*x3}{p_end}
{phang2}{cmd:. lincom 3*x1 + 500*x3 - 12}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}{p_end}

{pstd}Fit logistic regression, reporting coefficients{p_end}
{phang2}{cmd:. logit low age lwt i.race smoke ptl ht ui}{p_end}

{pstd}Estimate linear combination of coefficients; report odds ratio{p_end}
{phang2}{cmd:. lincom 2.race+smoke, or}{p_end}

{pstd}Fit logistic regression, reporting odds ratios{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}{p_end}

{pstd}{cmd:lincom} after {cmd:logistic} reports odds ratios by default{p_end}
{phang2}{cmd:. lincom 2.race+smoke}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site}{p_end}

{pstd}Estimate linear combination of coefficients from {cmd:Prepaid} equation
{p_end}
{phang2}{cmd:. lincom [Prepaid]male + [Prepaid]nonwhite}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lincom} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(estimate)}}point estimate{p_end}
{synopt:{cmd:r(se)}}estimate of standard error{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(t)} or {cmd:r(z)}}t or z statistic{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}
{synopt:{cmd:r(lb)}}lower bound of confidence interval{p_end}
{synopt:{cmd:r(ub)}}upper bound of confidence interval{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}
