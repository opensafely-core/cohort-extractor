{smcl}
{* *! version 1.1.5  18feb2020}{...}
{viewerdialog  predict "dialog rocreg_p"}{...}
{viewerdialog  "estat" "dialog rocreg_estat"}{...}
{vieweralsosee "[R] rocreg postestimation" "mansection R rocregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rocreg" "help rocreg"}{...}
{vieweralsosee "[R] rocregplot" "help rocregplot"}{...}
{viewerjumpto "Postestimation commands" "rocreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "rocreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "rocreg postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "rocreg postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "rocreg postestimation##examples"}{...}
{viewerjumpto "Stored results" "rocreg postestimation##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] rocreg postestimation} {hline 2}}Postestimation tools for rocreg{p_end}
{p2col:}({mansection R rocregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following commands are of special interest after {opt rocreg}:

{synoptset 13}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb rocreg_postestimation##estat_nproc:estat nproc}}nonparametric
    ROC curve estimation, keeping fit information from {cmd:rocreg}{p_end}
{synopt :{helpb rocregplot}}plot marginal and covariate-specific ROC curves
    {p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 13}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
{synopt :{helpb rocreg_postestimation##predict:predict}}predictions for
   parametric ROC curve estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rocregpostestimationRemarksandexamples:Remarks and examples}

        {mansection R rocregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opth at(varname)}}input variable for statistic{p_end}
{synopt:{opt auc}}total area under the ROC curve; the default{p_end}
{synopt:{opt roc}}ROC values for given false-positive rates in {cmd:at()}{p_end}
{synopt:{opt invroc}}false-positive rates for given ROC values in {cmd:at()}
{p_end}
{synopt:{opt pauc}}partial area under the ROC curve up to each
	false-positive rate in {cmd:at()}{p_end}
{synopt:{opth classvar(varname)}}statistic for given classifier{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt:{opt intpts(#)}}points in numeric integration of pAUC calculation{p_end}
{synopt:{opth se(newvar)}}predict standard errors {p_end}
{synopt:{opt ci(stubname)}}produce confidence intervals, stored as variables
	with prefix {it:stubname} and suffixes {cmd:_l} and {cmd:_u}{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{p2coldent:* {cmd:bfile(}{it:{help filename}}{cmd:,} ...{cmd:)}}load dataset
      containing bootstrap replicates from {cmd:rocreg} {p_end}
{p2coldent:* {cmd:btype(n} | {cmd:p} | {cmd:bc)}}produce normal-based ({cmd:n}),
 percentile ({cmd:p}), or bias-corrected ({cmd:bc}) confidence intervals;
 default is {cmd:btype(n)}{p_end}
{synoptline}
{p 4 6 2}* {opt bfile()} and {opt btype()} are only allowed with parametric
analysis using bootstrap inference.
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
Use of {cmd:predict} after fitting a parametric model with {cmd:rocreg} 
allows calculation of all the ROC curve summary statistics for 
covariate-specific ROC curves.  The ROC 
values for given false-positive rates, false-positive rate for given 
ROC values, area under the ROC curve (AUC), and 
partial areas under the ROC curve (pAUC) for a given 
false-positive rate can all be calculated.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opth at(varname)} records the variable to be used as input for the above
predictions.

{phang}
{opt auc} predicts the total area under the ROC curve defined by the 
covariate values in the data.  This is the default statistic.

{phang}
{opt roc} predicts the ROC values for false-positive rates stored in 
{varname} specified in {cmd:at()}.

{phang}
{opt invroc} predicts the false-positive rates for given ROC values stored in
{varname} specified in {cmd:at()}.

{phang} 
{opt pauc} predicts the partial area under the ROC curve up to each
false-positive rate stored in {varname} specified in {cmd:at()}.

{phang}
{opth classvar(varname)} performs the prediction for the specified classifier.

{dlgtab:Options}

{phang}
{opt intpts(#)} specifies that {it:#} points be used in the pAUC calculation.

{phang}
{opth se(newvar)} specifies that standard errors be produced and stored in
{it:newvar}.

{phang}
{opt ci(stubname)} requests that confidence intervals be produced and the
lower and upper bounds be stored in {it:stubname}{cmd:_l} and
{it:stubname}{cmd:_u}, respectively.

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:bfile(}{it:{help filename}}{cmd:,} ...{cmd:)} uses bootstrap replicates of
parameters from {cmd:rocreg} stored in {it:filename} to estimate standard
errors and confidence intervals of predictions.

{phang}
{cmd:btype(n} | {cmd:p} | {cmd:bc)} specifies whether to produce normal-based
({cmd:n}), percentile ({cmd:p}), or bias-corrected ({cmd:bc}) confidence
intervals.  The default is {cmd:btype(n)}.


{marker syntax_estat}{...}
{marker estat_nproc}{...}
{title:Syntax for estat nproc}

{p 8 16 2}
{cmd:estat nproc}  
[{cmd:,} {it:estat_nproc_options}]

{synoptset 23 tabbed}{...}
{synopthdr:estat_nproc_options}
{synoptline}
{syntab:Main}
{synopt:{opt auc}}estimate total area under the ROC curve{p_end}
{synopt:{cmd:roc(}{it:{help numlist}}{cmd:)}}estimate ROC for given false-positive rates{p_end}
{synopt:{cmd:invroc(}{it:{help numlist}}{cmd:)}}estimate false-positive rate
for given ROC values {p_end}
{synopt:{cmd:pauc(}{it:{help numlist}}{cmd:)}}estimate partial area under the
ROC curve up to each false-positive rate{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
At least one option must be specified.
{p_end}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat nproc} allows calculation of all the ROC curve
summary statistics for covariate-specific ROC curves, as well as
for a nonparametric ROC estimation.  Under nonparametric estimation,
a single ROC curve is estimated by {cmd:rocreg}.  Covariates can
affect this estimation, but there are no separate covariate-specific
ROC curves.  Thus, the input arguments for {cmd:estat nproc} are taken
in the command line rather than from the data as variable values.


{marker options_estat}{...}
{title:Options for estat nproc}

{dlgtab:Main}

{phang} 
{opt auc} estimates the total area under the ROC curve.  

{phang}
{opth roc(numlist)} estimates the ROC for each of the false-positive rates in
{it:numlist}.  The values in {it:numlist} must be in the range (0,1).

{phang}
{opth invroc(numlist)} estimates the false-positive rate for each of the ROC
values in {it:numlist}.  The values in {it:numlist} must be in the range (0,1).

{phang}
{opth pauc(numlist)} estimates the partial area under the ROC curve up to
each false-positive rate in {it:numlist}.  The values in {it:numlist} must be
in the range (0,1].


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hanley}{p_end}

{pstd}Fit a smooth ROC curve assuming a binormal model{p_end}
{phang2}{cmd:. rocreg disease rating, probit ml}{p_end}
{phang2}{cmd:. generate rocinp = .2 if _n == 1}{p_end}
{phang2}{cmd:. predict double rocval if _n == 1, roc at(rocinp) se(ser) ci(cir)}{p_end}
{phang2}{cmd:. list rocinp rocval ser cir* if _n == 1}{p_end}

{pstd}Fit a nonparametric ROC curve{p_end}
{phang2}{cmd:. rocreg disease rating, invroc(.5) bseed(32)}{p_end}
{phang2}{cmd:. estat nproc, pauc(.5)}{p_end}

    {hline}
{pstd}Setup of dataset with multiple covariates{p_end}
{phang2}{cmd:. webuse nnhs, clear}{p_end}

{pstd}Fit a binormal ROC curve to data, with control/ROC covariates and
bootstrap inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
        {cmd:roccov(currage) cluster(id) bseed(56930) breps(50) bsave(nnhs2y1)}
        {cmd:probit}{p_end}

{pstd}Fit a binormal ROC curve to data, with control/ROC covariates and maximum
likelihood inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
        {cmd:roccov(currage) cluster(id) probit ml}{p_end}
{phang2}{cmd:. local n = _N+3}{p_end}
{phang2}{cmd:. set obs `n'}{p_end}
{phang2}{cmd:. qui replace currage = 30 if _n== _N-2}{p_end}
{phang2}{cmd:. qui replace currage = 40 if _n== _N-1}{p_end}
{phang2}{cmd:. qui replace currage = 50 if _n== _N}{p_end}
{phang2}{cmd:. predict double predAUC if _n > _N-3, auc se(seAUC) ci(ciAUC)}
{p_end}
{phang2}{cmd:. list currage *AUC* if _n > _N-3}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat nproc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}coefficient vector{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:r(ci_normal)}}normal-approximation confidence intervals{p_end}
{synopt:{cmd:r(ci_percentile)}}percentile confidence intervals{p_end}
{synopt:{cmd:r(ci_bc)}}bias-corrected confidence intervals{p_end}
