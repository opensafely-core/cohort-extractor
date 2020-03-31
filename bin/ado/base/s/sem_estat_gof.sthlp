{smcl}
{* *! version 1.0.13  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-gof-) name(sem_estat_gof)"}{...}
{vieweralsosee "[SEM] estat gof" "mansection SEM estatgof"}{...}
{findalias assemgof}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqgof" "help sem_estat_eqgof"}{...}
{vieweralsosee "[SEM] estat ggof" "help sem_estat_ggof"}{...}
{vieweralsosee "[SEM] estat residuals" "help sem_estat_residuals"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat ic" "help estat ic"}{...}
{viewerjumpto "Syntax" "sem_estat_gof##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_gof##menu"}{...}
{viewerjumpto "Description" "sem_estat_gof##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_gof##linkspdf"}{...}
{viewerjumpto "Options" "sem_estat_gof##options"}{...}
{viewerjumpto "Remarks" "sem_estat_gof##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_gof##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_gof##results"}{...}
{viewerjumpto "References" "sem_estat_gof##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[SEM] estat gof} {hline 2}}Goodness-of-fit statistics{p_end}
{p2col:}({mansection SEM estatgof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:gof} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt st:ats(statlist)}}statistics to be displayed{p_end}
{synopt:{opt nodes:cribe}}suppress descriptions of statistics{p_end}
{synoptline}

{marker statlist}{...}
{synoptset 20}{...}
{synopthdr:statlist}
{synoptline}
{synopt:{opt chi2}}chi-squared tests; the default{p_end}
{synopt:{opt rms:ea}}root mean squared error of approximation{p_end}
{synopt:{opt ic}}information indices{p_end}
{synopt:{opt ind:ices}}indices for comparison against baseline{p_end}
{synopt:{opt res:iduals}}measures based on residuals{p_end}
{synopt:{cmd:all}}all the above{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Note:  The statistics reported by {cmd:chi2}, {cmd:rmsea}, and
       {cmd:indices} are dependent on the assumption of joint normality of
       the observed variables.  If {cmd: vce(sbentler)} is specified with 
       {cmd:sem}, modified versions of these statistics that are computed 
       using the Satorra-Bentler scaled chi-squared statistics will
       also be reported.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Goodness of fit > Overall goodness of fit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat gof} is for use after {cmd:sem} but not {cmd:gsem}.

{pstd}
{cmd:estat gof} displays a variety of overall goodness-of-fit statistics.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatgofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opth stats:(sem_estat_gof##statlist:statlist)}
specifies the statistics to be displayed.  The default is {cmd:stats(chi2)}.

{phang2}{cmd:stats(chi2)}
reports the model versus saturated test and the baseline versus saturated test.
The saturated model is the model that fits the covariances perfectly.

{pmore2}
The model versus saturated test is a repeat of the test reported at the bottom
of the {cmd:sem} output.

{pmore2}
In the baseline versus saturated test, the baseline model includes the means
and variances of all observed variables plus the covariances of all observed
exogenous variables.  For a covariance model (a model with no endogenous
variables), the baseline includes only the means and variances of observed
variables.  Be aware that different authors define the baseline model
differently.

{phang2}{cmd:stats(rmsea)}
reports the root mean squared error of approximation (RMSEA) and its 90%
confidence interval, and pclose, the p-value for a test of close fit, namely,
RMSEA < 0.05.  Most interpreters of this test label the fit close if the lower
bound of the 90% CI is below 0.05 and label the fit poor if the upper bound is
above 0.10.  See {help sem_estat_gof##Browne1993:Browne and Cudeck (1993)}.

{phang2}{cmd:stats(ic)}
reports the Akaike information criterion (AIC) and the Bayesian (or Schwarz)
information criterion (BIC).  These statistics are available only after
estimation with {cmd:sem} {cmd:method(ml)} or {cmd:method(mlmv)}.  These
statistics are used not to judge fit in absolute terms but instead to compare
the fit of different models.  Smaller values indicate a better fit.  Be aware
that there are many variations (minor adjustments) to statistics labeled AIC
and BIC.  Reported here are statistics that match {cmd:estat ic}; see
{helpb estat:[R] estat}.

{pmore2}To compare models use statistics based on likelihoods, such as AIC and
BIC, models should include the same variables;
see {helpb sem lrtest:[SEM] lrtest}.  See
{help sem_estat_gof##Akaike1987:Akaike (1987)},
{help sem_estat_gof##Schwarz1978:Schwarz (1978)}, and
{help sem_estat_gof##Raftery1993:Raftery (1993)}.

{phang2}{cmd:stats(indices)}
reports CFI and TLI, two indices such that a value close to 1 indicates a good
fit.  CFI stands for comparative fit index.  TLI stands for Tucker-Lewis index
and is also known as the nonnormed fit index.  See
{help sem_estat_gof##Bentler1990:Bentler (1990)}.

{phang2}{cmd:stats(residuals)}
reports the standardized root mean squared residual (SRMR) and the
coefficient of determination (CD).

{pmore2}
A perfect fit corresponds to an SRMR of 0.  A good fit is a small value,
considered by some to be limited to 0.08.

{pmore2}
Concerning CD, a perfect fit corresponds to a CD of 1.  CD is like R-squared
for the whole model.

{phang2}{cmd:stats(all)}
reports all the statistics.  You can also specify just the statistics you wish
reported, such as 

{phang3}{cmd:. estat gof, stats(indices residuals)}

{phang}{opt nodescribe}
suppresses the descriptions of the goodness-of-fit measures.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semgof}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Display all goodness-of-fit statistics{p_end}
{phang2}{cmd:. estat gof, stats(all)}{p_end}

{pstd}Suppress descriptions of statistics{p_end}
{phang2}{cmd:. estat gof, stats(all) nodescribe}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat gof} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(chi2_ms)}}test of target model against saturated model{p_end}
{synopt:{cmd:r(df_ms)}}degrees of freedom for {cmd:r(chi2_ms)}{p_end}
{synopt:{cmd:r(p_ms)}}p-value for {cmd:r(chi2_ms)}{p_end}
{synopt:{cmd:r(chi2sb_ms)}}Satorra-Bentler scaled test of target model against saturated model{p_end}
{synopt:{cmd:r(psb_ms)}}p-value for {cmd:r(chi2sb_ms)}{p_end}
{synopt:{cmd:r(chi2_bs)}}test of baseline model against saturated model{p_end}
{synopt:{cmd:r(df_bs)}}degrees of freedom for {cmd:r(chi2_bs)}{p_end}
{synopt:{cmd:r(p_bs)}}p-value for {cmd:r(chi2_bs)}{p_end}
{synopt:{cmd:r(chi2sb_bs)}}Satorra-Bentler scaled test of baseline model against saturated model{p_end}
{synopt:{cmd:r(psb_bs)}}p-value for {cmd:r(chi2sb_bs)}{p_end}
{synopt:{cmd:r(rmsea)}}root mean squared error of approximation{p_end}
{synopt:{cmd:r(lb90_rmsea)}}lower bound of 90% CI for RMSEA{p_end}
{synopt:{cmd:r(ub90_rmsea)}}upper bound of 90% CI for RMSEA{p_end}
{synopt:{cmd:r(pclose)}}p-value for test of close fit: RMSEA < 0.05{p_end}
{synopt:{cmd:r(rmsea_sb)}}RMSEA using Satorra-Bentler chi-squared{p_end}
{synopt:{cmd:r(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:r(bic)}}Bayesian information criterion{p_end}
{synopt:{cmd:r(cfi)}}comparative fit index{p_end}
{synopt:{cmd:r(cfi_sb)}}CFI using Satorra-Bentler chi-squared{p_end}
{synopt:{cmd:r(tli)}}Tucker-Lewis fit index{p_end}
{synopt:{cmd:r(tli_sb)}}TLI using Satorra-Bentler chi-squared{p_end}
{synopt:{cmd:r(cd)}}coefficient of determination{p_end}
{synopt:{cmd:r(srmr)}}standardized root mean squared residual{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(nobs)}}sample size for each group{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker Akaike1987}{...}
{phang}
Akaike, H.  1987.  Factor analysis and AIC.  {it:Psychometrika} 52: 317-332.

{marker Bentler1990}{...}
{phang}
Bentler, P. M.  1990.  Comparative fit indices in structural models.  
{it:Psychological Bulletin} 107: 238-246.

{marker Browne1993}{...}
{phang}
Browne, M. W., and R. Cudeck.  1993.  Alternative ways of assessing model fit.
Reprinted in {it:Testing Structural Equation Models},
ed. K. A. Bollen and J. S. Long, 136-162.  Newbury Park, CA: Sage.

{marker Raftery1993}{...}
{phang}
Raftery, A. E.  1993.  Bayesian model selection in structural equation models.
Reprinted In {it:Testing Structural Equation Models},
ed. K. A. Bollen and J. S. Long, 163-180.  Newbury Park, CA: Sage.

{marker Schwarz1978}{...}
{phang}
Schwarz, G. 1978.  Estimating the dimension of a model.  
{it:Annals of Statistics} 6: 461-464.
{p_end}
