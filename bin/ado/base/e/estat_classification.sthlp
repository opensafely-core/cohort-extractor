{smcl}
{* *! version 1.0.5  24oct2017}{...}
{viewerdialog estat "dialog logit_estat"}{...}
{vieweralsosee "[R] estat classification" "mansection R estatclassification"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat gof" "help logistic estat gof"}{...}
{vieweralsosee "[R] lroc" "help lroc"}{...}
{vieweralsosee "[R] lsens" "help lsens"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{viewerjumpto "Syntax" "estat classification##syntax"}{...}
{viewerjumpto "Menu for estat" "estat classification##menu_estat"}{...}
{viewerjumpto "Description" "estat classification##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_classification##linkspdf"}{...}
{viewerjumpto "Options" "estat classification##options"}{...}
{viewerjumpto "Example" "estat classification##example"}{...}
{viewerjumpto "Stored results" "estat classification##results"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] estat classification} {hline 2}}Classification statistics
and table{p_end}
{p2col:}({mansection R estatclassification:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt clas:sification} {ifin}
[{it:{help estat classification##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt all}}display summary statistics for all observations in the data{p_end}
{synopt :{opt cut:off(#)}}positive outcome threshold; default is
{cmd:cutoff(0.5)}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}{cmd:estat} {cmd:classification} is not appropriate after the {cmd:svy}
  prefix.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat classification} reports various summary statistics, including the
classification table.

{pstd}
{cmd:estat classification} requires that the current estimation results be
from {helpb logistic}, {helpb logit}, {helpb probit}, or {helpb ivprobit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estatclassificationQuickstart:Quick start}

        {mansection R estatclassificationRemarksandexamples:Remarks and examples}

        {mansection R estatclassificationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt all} requests that the statistic be computed for all observations in the
data, ignoring any {opt if} or {opt in} restrictions specified by
the estimation command.

{phang}
{opt cutoff(#)} specifies the value for determining whether an observation has
a predicted positive outcome.  An observation is classified as positive if its
predicted probability is {ul:>} {it:#}.  The default is 0.5.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}Fit logistic regression to predict low birth weight{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}

{pstd}Report classification table and summary statistics{p_end}
{phang2}{cmd:. estat classification}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat classification} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(P_corr)}}percent correctly classified{p_end}
{synopt:{cmd:r(P_p1)}}sensitivity{p_end}
{synopt:{cmd:r(P_n0)}}specificity{p_end}
{synopt:{cmd:r(P_p0)}}false-positive rate given true negative{p_end}
{synopt:{cmd:r(P_n1)}}false-negative rate given true positive{p_end}
{synopt:{cmd:r(P_1p)}}positive predictive value{p_end}
{synopt:{cmd:r(P_0n)}}negative predictive value{p_end}
{synopt:{cmd:r(P_0p)}}false-positive rate given classified positive{p_end}
{synopt:{cmd:r(P_1n)}}false-negative rate given classified negative{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ctable)}}classification table{p_end}
{p2colreset}{...}
