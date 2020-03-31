{smcl}
{* *! version 1.0.13  20sep2018}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance summarize" "mansection TE tebalancesummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[TE] stteffects ipw" "help stteffects ipw"}{...}
{vieweralsosee "[TE] stteffects ipwra" "help stteffects ipwra"}{...}
{vieweralsosee "[TE] tebalance" "help tebalance"}{...}
{vieweralsosee "[TE] teffects aipw" "help teffects aipw"}{...}
{vieweralsosee "[TE] teffects ipw" "help teffects ipw"}{...}
{vieweralsosee "[TE] teffects ipwra" "help teffects ipwra"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{vieweralsosee "[TE] teffects overlap" "help teffects overlap"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{viewerjumpto "Syntax" "tebalance summarize##syntax"}{...}
{viewerjumpto "Menu" "tebalance summarize##menu"}{...}
{viewerjumpto "Description" "tebalance summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "tebalance_summarize##linkspdf"}{...}
{viewerjumpto "Option" "tebalance summarize##option"}{...}
{viewerjumpto "Example" "tebalance summarize##example"}{...}
{viewerjumpto "Stored results" "tebalance summarize##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[TE] tebalance summarize} {hline 2}}Covariate-balance summary
statistics{p_end}
{p2col:}({mansection TE tebalancesummarize:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:tebalance} {cmd:summarize} [{varlist}] [{cmd:,} {cmdab:base:line}]

{pstd}
{it:varlist} may contain factor variables; see {help fvvarlist}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Balance > Summaries}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tebalance summarize} reports diagnostic statistics that are used to check
for covariate balance over treatment groups after estimation by a
{helpb teffects} inverse-probability-weighted estimator, a {cmd:teffects}
matching estimator, or an {helpb stteffects} inverse-probability-weighted
estimator.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE tebalancesummarizeQuickstart:Quick start}

        {mansection TE tebalancesummarizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Main}

{phang}
{cmd:baseline} specifies that {cmd:tebalance summarize} report means and
variances by treatment level.


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
({cmd:fbaby}){p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried mage prenatal1 fbaby), generate(matchv)}

{pstd}
Look at the standardized differences and variance ratios for the raw
data and the matched sample{p_end}
{phang2}{cmd:. tebalance summarize}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tebalance} {cmd:summarize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 24 28 2:Matrices}{p_end}
{synopt :{cmd:r(size)}}number of observations in the raw and matched or
weighted samples{p_end}
{synopt :{cmd:r(table)}}table of covariate statistics{p_end}
