{smcl}
{* *! version 1.0.13  20sep2018}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance overid" "mansection TE tebalanceoverid"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[TE] tebalance" "help tebalance"}{...}
{vieweralsosee "[TE] teffects aipw" "help teffects aipw"}{...}
{vieweralsosee "[TE] teffects ipw" "help teffects ipw"}{...}
{vieweralsosee "[TE] teffects ipwra" "help teffects ipwra"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{viewerjumpto "Syntax" "tebalance overid##syntax"}{...}
{viewerjumpto "Menu" "tebalance overid##menu"}{...}
{viewerjumpto "Description" "tebalance overid##description"}{...}
{viewerjumpto "Links to PDF documentation" "tebalance_overid##linkspdf"}{...}
{viewerjumpto "Options" "tebalance overid##options"}{...}
{viewerjumpto "Example" "tebalance overid##example"}{...}
{viewerjumpto "Stored results" "tebalance overid##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[TE] tebalance overid} {hline 2}}Test for covariate balance{p_end}
{p2col:}({mansection TE tebalanceoverid:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:tebalance} {cmd:overid} [{cmd:,} {cmdab:bco:nly}
{cmd:nolog} {opt iter:ate(#)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Balance > Overidentification test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tebalance overid} performs a test for covariate balance after estimation
by a {helpb teffects} inverse-probability-weighted estimator
or an {helpb stteffects} inverse-probability-weighted estimator.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE tebalanceoveridQuickstart:Quick start}

        {mansection TE tebalanceoveridRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:bconly} specifies that only the base covariates be included in the
test for balance.  By default, the powers and interactions specified by
factor-variable notation in the {cmd:teffects} or {cmd:stteffects} model
are also included in the test for balance.

{phang}
{cmd:nolog} suppresses the display of the optimization search log.

{phang}
{cmd:iterate(}{it:#}{cmd:)} sets the maximum number of iterations to
{it:#} in the generalized method of moments estimator used to compute
the test statistic.


{marker example}{...}
{title:Example}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the effect of a mother's smoking behavior ({cmd:mbsmoke}) on
the birthweight of her child ({cmd:bweight}), controlling for marital
status ({cmd:mmarried}), the mother's age ({cmd:mage}), whether the
mother had a prenatal doctor's visit in the baby's first trimester
({cmd:prenatal1}), and whether this baby is the mother's first child
({cmd:fbaby}).  In addition to the base covariates, we include the
square of {cmd:mage}, an interaction between {cmd:mage} and
{cmd:mmarried}, and an interaction between {cmd:mage} and
{cmd:prenatal1} in the model for the propensity score.{p_end}
{phang2}{cmd:. teffects ipw (bweight) (mbsmoke mmarried mage prenatal1 fbaby c.mage#(c.mage i.mmarried prenatal1)), aequations}

{pstd}
Test whether the model balances all eight covariates{p_end}
{phang2}{cmd:. tebalance overid}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tebalance} {cmd:overid} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 24 28 2:Scalars}{p_end}
{synopt :{cmd:r(p)}}p-value{p_end}
{synopt :{cmd:r(df)}}overidentifying constraints, test degrees of freedom{p_end}
{synopt :{cmd:r(chi2)}}chi-squared statistic{p_end}
