{smcl}
{* *! version 1.0.8  19oct2017}{...}
{viewerdialog estat "dialog logit_estat"}{...}
{vieweralsosee "[R] estat gof" "mansection R estatgof"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat classification" "help estat classification"}{...}
{vieweralsosee "[R] lroc" "help lroc"}{...}
{vieweralsosee "[R] lsens" "help lsens"}{...}
{viewerjumpto "Syntax" "logistic estat gof##syntax"}{...}
{viewerjumpto "Menu for estat" "logistic estat gof##menu_estat"}{...}
{viewerjumpto "Description" "logistic estat gof##description"}{...}
{viewerjumpto "Links to PDF documentation" "logistic_estat_gof##linkspdf"}{...}
{viewerjumpto "Options" "logistic estat gof##options"}{...}
{viewerjumpto "Examples" "logistic estat gof##examples"}{...}
{viewerjumpto "Stored results" "logistic estat gof##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] estat gof} {hline 2}}Pearson or Hosmer-Lemeshow
goodness-of-fit test{p_end}
{p2col:}({mansection R estatgof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat gof} {ifin}
[{it:{help logistic estat gof##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr :gof_options}
{synoptline}
{syntab :Main}
{synopt :{opt g:roup(#)}}perform Hosmer-Lemeshow goodness-of-fit test using
{it:#} quantiles{p_end}
{synopt :{opt all}}execute test for all observations in the data{p_end}
{synopt :{opt out:sample}}adjust degrees of freedom for samples outside
estimation sample{p_end}
{synopt :{opt t:able}}display table of groups used for test{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}{cmd:estat} {cmd:gof} is not appropriate after the {cmd:svy} prefix.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat gof} reports the Pearson goodness-of-fit test or the
Hosmer-Lemeshow goodness-of-fit test.

{pstd}
{cmd:estat gof} requires that the current estimation results be from
{helpb logistic}, {helpb logit}, or {helpb probit}.  For {cmd:estat gof} after
{cmd:poisson}, see {helpb poisson postestimation:[R] poisson postestimation}.
For {cmd:estat gof} after {cmd:sem}, see {helpb sem estat gof:[SEM] estat gof}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estatgofQuickstart:Quick start}

        {mansection R estatgofRemarksandexamples:Remarks and examples}

        {mansection R estatgofMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt group(#)} specifies the number of quantiles to be used to group the data
for the Hosmer-Lemeshow goodness-of-fit test.  {cmd:group(10)} is typically
specified.  If this option is not given, the Pearson goodness-of-fit test is
computed using the covariate patterns in the data as groups.

{phang}
{opt all} requests that the statistic be computed for all observations in the
data, ignoring any {opt if} or {opt in} restrictions specified by the
estimation command.

{phang}
{opt outsample} adjusts the degrees of freedom for the Pearson and
Hosmer-Lemeshow goodness-of-fit tests for samples outside the estimation
sample.  See
{mansection R estatgofRemarksandexamplesSamplesotherthantheestimationsample:{it:Samples other than the estimation sample}}
in {bf:[R] estat gof}.

{phang}
{opt table} displays a table of the groups used for the Hosmer-Lemeshow or
Pearson goodness-of-fit test with predicted probabilities, observed and
expected counts for both outcomes, and totals for each group.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}Fit logistic regression to predict low birth weight{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}

{pstd}Perform goodness-of-fit test{p_end}
{phang2}{cmd:. estat gof}

{pstd}Same as above, but use 10 quantiles{p_end}
{phang2}{cmd:. estat gof, group(10)}

{pstd}Same as above, but display table of groups used for test{p_end}
{phang2}{cmd:. estat gof, group(10) table}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat gof} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(m)}}number of covariate patterns or groups{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(p)}}p-value for chi-squared test{p_end}
{p2colreset}{...}
