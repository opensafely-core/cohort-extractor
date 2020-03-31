{smcl}
{* *! version 1.0.6  20sep2018}{...}
{viewerdialog tebalance "dialog tebalance"}{...}
{vieweralsosee "[TE] tebalance" "mansection TE tebalance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[TE] tebalance box" "help tebalance box"}{...}
{vieweralsosee "[TE] tebalance density" "help tebalance density"}{...}
{vieweralsosee "[TE] tebalance overid" "help tebalance overid"}{...}
{vieweralsosee "[TE] tebalance summarize" "help tebalance summarize"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Syntax" "tebalance##syntax"}{...}
{viewerjumpto "Description" "tebalance##description"}{...}
{viewerjumpto "Links to PDF documentation" "tebalance##linkspdf"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TE] tebalance} {hline 2}}Check balance after teffects or stteffects estimation{p_end}
{p2col:}({mansection TE tebalance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:tebalance} {it:subcommand} ... [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{helpb tebalance summarize:summarize}}compare means and variances in
raw and balanced data{p_end}
{synopt :{helpb tebalance overid:overid}}overidentification test{p_end}
{synopt :{helpb tebalance density:density}}kernel density plots for raw and balanced data{p_end}
{synopt :{helpb tebalance box:box}}box plots for each treatment level for
balanced data{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:tebalance} postestimation commands produce diagnostic
statistics, test statistics, and diagnostic plots to assess whether a
{helpb teffects} or an {helpb stteffects} command balanced the covariates
over treatment levels.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE tebalanceRemarksandexamples:Remarks and examples}

        {mansection TE tebalanceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


