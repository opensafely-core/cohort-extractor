{smcl}
{* *! version 1.0.5  19oct2017}{...}
{viewerdialog stteffects "dialog stteffects"}{...}
{vieweralsosee "[TE] stteffects intro" "mansection TE stteffectsintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro advanced" "mansection TE teffectsintroadvanced"}{...}
{vieweralsosee "[TE] stteffects postestimation" "help stteffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Description" "stteffects intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "stteffects_intro##linkspdf"}{...}
{viewerjumpto "Remarks" "stteffects intro##remarks"}{...}
{viewerjumpto "References" "stteffects intro##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[TE] stteffects intro} {hline 2}}Introduction to treatment
effects for observational survival-time data{p_end}
{p2col:}({mansection TE stteffectsintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides an overview of the treatment-effects estimators that use
observational survival-time data and are implemented in {cmd:stteffects}.  It
also provides an overview of the potential-outcomes framework and its
application to survival-time data and to the interpretation of the
treatment-effects parameters estimated.

{pstd}
The {cmd:stteffects} command estimates average treatment effects, average
treatment effects on the treated, and potential-outcome means.  Each of these
effect parameters is discussed in this entry.  {cmd:stteffects} implements a
variety of estimators for the average treatment effects, average treatment
effects on the treated, and potential-outcome means.  The treatment effects
can be estimated using regression adjustment, inverse-probability weights,
inverse-probability-weighted regression adjustment, and weighted
regression adjustment.  This entry also provides some intuition for the
estimators and discusses the trade-offs between them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE stteffectsintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks: A quick tour of the estimators}

{pstd}
The {cmd:stteffects} command implements five estimators of treatment effects.
We introduce each one by showing the basic syntax used to apply it to a common
example dataset.  See each command's entry for detailed information.


    {bf:Regression adjustment}

{pstd}
Regression modeling of the outcome variable is a venerable approach to
solving the missing-data problem in treatment-effects estimation.  Known as
the regression-adjustment (RA) estimator, this method uses averages of
predicted outcomes to estimate the ATE.  If the outcome model is
well specified, this approach is surprisingly robust.

{pstd}
We use {cmd:stteffects ra} to estimate the ATE by RA.  We model the outcome as
a function of {cmd:age}, {cmd:exercise}, {cmd:diet}, and {cmd:education}, and
we specify that {cmd:smoke} is the treatment variable.

{phang2}{cmd:. webuse sheart}{p_end}
{phang2}{cmd:. stset atime, failure(fail)}{p_end}
{phang2}{cmd:. stteffects ra (age exercise diet education) (smoke)}


    {bf:Inverse-probability weighting}

{pstd}
Inverse-probability-weighted (IPW) estimators use
weighted averages of the observed outcome to estimate the POMs and
the ATE.  The weights correct for the missing data.  When there is
no censoring, the missing potential outcome is the only missing data, and the
weights are constructed from a model of treatment assignment.  When the data
may be censored, the weights must control for censoring and the missing
potential outcome.  In this case, IPW estimators construct the
weights from two models, one for the censoring time and one for treatment
assignment.

{pstd}
Here we use {cmd:stteffects ipw} to estimate the effect of smoking on the
time to a second heart attack.  The model of assignment to the treatment
{cmd:smoke} depends on {cmd:age}, {cmd:exercise}, {cmd:diet}, and
{cmd:education}.  The time-to-censoring model also depends on {cmd:age},
{cmd:exercise}, {cmd:diet}, and {cmd:education}.

{phang2}{cmd:. stteffects ipw (smoke age exercise diet education)}
        {cmd:(age exercise diet education)}


    {bf:Combinations of RA and IPW}

{pstd}
More efficient estimators are obtained by combining IPW and RA, due to
{help stteffects intro##W2007:Wooldridge (2007)} and
{help stteffects intro##W2010:Wooldridge (2010, chap. 21)} and denoted by
IPWRA.  Unlike the estimators discussed in
{help stteffects intro##W2010:Wooldridge (2010, chap. 21)}, 
both the treatment and the outcome models must be correctly specified to
estimate the ATE.

{pstd}
The IPWRA estimator uses estimated weights that control for missing
data to obtain missingness-adjusted regression coefficients that are used to
compute averages of predicted outcomes to estimate the POMs. The
estimated ATE is a contrast of the estimated POMs.  These
weights always involve a model for treatment assignment.  You choose whether
to account for censoring by including a term in the log-likelihood function or
whether to use weights that also account for the data lost to censoring.

{pstd}
We model the outcome (time to a second heart attack) as a function of
{cmd:age}, {cmd:exercise}, {cmd:diet}, and {cmd:education}.  We model
assignment to the treatment {cmd:smoke} as a function of the same covariates.

{phang2}{cmd:. stteffects ipwra (age exercise diet education)}
        {cmd:(smoke age exercise diet education)}


    {bf:Weighted regression adjustment}

{pstd}
When estimating the parameters of an outcome model, the weighted
regression-adjustment (WRA) estimator uses weights instead of a term
in the log-likelihood function to adjust for censoring.  These weights are
constructed from a model for the censoring process.  The estimated
parameters are subsequently used to compute averages of predicted outcomes
that estimate the POMs.  A contrast of the estimated POMs
estimates the ATE.

{pstd}
We model the time to a second heart attack as a function of {cmd:age},
{cmd:exercise}, {cmd:diet}, and {cmd:education}; we specify that {cmd:smoke}
is the treatment as a function of the same covariates.

{phang2}{cmd:. stteffects wra (age exercise diet education)}
        {cmd:(smoke) (age exercise diet)}


{marker references}{...}
{title:References}

{marker W2007}{...}
{phang}
Wooldridge, J. M. 2007. Inverse probability weighted estimation for
general missing data problems. {it:Journal of Econometrics} 141: 1281-1301.

{marker W2010}{...}
{phang}
------. 2010.
{browse "http://www.stata.com/bookstore/econometric-analysis-cross-section-panel-data/":{it:Econometric Analysis of Cross Section and Panel Data}}. 2nd ed.
Cambridge, MA: MIT Press.
