{smcl}
{* *! version 2.2.11  11dec2018}{...}
{viewerdialog qreg "dialog qreg"}{...}
{viewerdialog iqreg "dialog iqreg"}{...}
{viewerdialog sqreg "dialog sqreg"}{...}
{viewerdialog bsqreg "dialog bsqreg"}{...}
{vieweralsosee "[R] qreg" "mansection R qreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] qreg postestimation" "help qreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] rreg" "help rreg"}{...}
{viewerjumpto "Syntax" "qreg##syntax"}{...}
{viewerjumpto "Menu" "qreg##menu"}{...}
{viewerjumpto "Description" "qreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "qreg##linkspdf"}{...}
{viewerjumpto "Options for qreg" "qreg##options_qreg"}{...}
{viewerjumpto "Options for iqreg" "qreg##options_iqreg"}{...}
{viewerjumpto "Options for sqreg" "qreg##options_sqreg"}{...}
{viewerjumpto "Options for bsqreg" "qreg##options_bsqreg"}{...}
{viewerjumpto "Examples" "qreg##examples"}{...}
{viewerjumpto "Stored results" "qreg##results"}{...}
{viewerjumpto "References" "qreg##references"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] qreg} {hline 2}}Quantile regression{p_end}
{p2col:}({mansection R qreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Quantile regression

{p 8 13 2}
{cmd:qreg} {depvar} [{indepvars}] {ifin} 
[{it:{help qreg##weight:weight}}]
	[{cmd:,} {it:{help qreg##qreg_options:qreg_options}}]


{phang}
Interquantile range regression

{p 8 14 2}
{cmd:iqreg} {depvar} [{indepvars}] {ifin}
	[{cmd:,} {it:{help qreg##iqreg_options:iqreg_options}}]


{phang}
Simultaneous-quantile regression

{p 8 14 2}
{cmd:sqreg} {depvar} [{indepvars}] {ifin}
	[{cmd:,} {it:{help qreg##sqreg_options:sqreg_options}}]


{phang}
Bootstrapped quantile regression

{p 8 15 2}
{cmd:bsqreg} {depvar} [{indepvars}] {ifin}
	[{cmd:,} {it:{help qreg##bsqreg_options:bsqreg_options}}]


{synoptset 26 tabbed}{...}
{marker qreg_options}{...}
{synopthdr :qreg_options}
{synoptline}
{syntab :Model}
{synopt :{opt q:uantile(#)}}estimate {it:#} quantile; default is {cmd:quantile(.5)}{p_end}

{syntab:SE/Robust}
{synopt :{cmd:vce(}[{it:{help qreg##qreg_vcetype:vcetype}}]{cmd:,} [{it:{help qreg##qreg_vceopts:vceopts}}]{cmd:)}}technique
	used to estimate standard errors{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help qreg##qreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Optimization}
{synopt :{it:{help qreg##qreg_optimize:optimization_options}}}control the
optimization process; seldom used{p_end}
{synopt :{opt wls:iter(#)}}attempt {it:#} weighted least-squares iterations before doing linear programming iterations{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26}{...}
{marker qreg_vcetype}{...}
{synopthdr :vcetype}
{synoptline}
{synopt :{opt iid}}compute the VCE assuming the residuals are i.i.d.{p_end}
{synopt :{opt r:obust}}compute the robust VCE{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26}{...}
{marker qreg_vceopts}{...}
{synopthdr :vceopts}
{synoptline}
{synopt :{it:{help qreg##qreg_method:denmethod}}}nonparametric density estimation
	technique{p_end}
{synopt :{it:{help qreg##qreg_bwidth:bwidth}}}bandwidth method used by the 
	density estimator{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26}{...}
{marker qreg_method}{...}
{synopthdr :denmethod}
{synoptline}
{synopt :{opt fit:ted}}use the empirical quantile function using fitted values;
	the default{p_end}
{synopt :{opt res:idual}}use the empirical residual quantile function{p_end}
{synopt :{opt ker:nel}[{cmd:(}{it:{help qreg##qreg_kernel:kernel}}{cmd:)}]}use
	a nonparametric kernel density estimator; default is {cmd:epanechnikov}
	{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26}{...}
{marker qreg_bwidth}{...}
{synopthdr :bwidth}
{synoptline}
{synopt :{opt hs:heather}}Hall-Sheather's bandwidth; the default{p_end}
{synopt :{opt bo:finger}}Bofinger's bandwidth{p_end}
{synopt :{opt ch:amberlain}}Chamberlain's bandwidth{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26}{...}
{marker qreg_kernel}{...}
{synopthdr :kernel}
{synoptline}
{synopt :{opt ep:anechnikov}}Epanechnikov kernel function; the default{p_end}
{synopt :{opt epan2}}alternative Epanechnikov kernel function{p_end}
{synopt :{opt bi:weight}}biweight kernel function{p_end}
{synopt :{opt cos:ine}}cosine trace kernel function{p_end}
{synopt :{opt gau:ssian}}Gaussian kernel function{p_end}
{synopt :{opt par:zen}}Parzen kernel function{p_end}
{synopt :{opt rec:tangle}}rectangle kernel function{p_end}
{synopt :{opt tri:angle}}triangle kernel function{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 26 tabbed}{...}
{marker iqreg_options}{...}
{synopthdr :iqreg_options}
{synoptline}
{syntab :Model}
{synopt :{opt q:uantiles(# #)}}interquantile range; default is {bind:{cmd:quantiles(.25 .75)}}{p_end}
{synopt :{opt r:eps(#)}}perform {it:#} bootstrap replications; default is {cmd:reps(20)}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nod:ots}}suppress display of the replication dots{p_end}
{synopt :{it:{help qreg##iqreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synoptline}
{p2colreset}{...}


{synoptset 26 tabbed}{...}
{marker sqreg_options}{...}
{synopthdr :sqreg_options}
{synoptline}
{syntab :Model}
{synopt :{cmdab:q:uantiles(}{it:#}[{it:#}[{it:# ...}]]{cmd:)}}estimate {it:#} quantiles; default is {cmd:quantiles(.5)}{p_end}
{synopt :{opt r:eps(#)}}perform {it:#} bootstrap replications; default is {cmd:reps(20)}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nod:ots}}suppress display of the replication dots{p_end}
{synopt :{it:{help qreg##sqreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synoptline}
{p2colreset}{...}


{synoptset 26 tabbed}{...}
{marker bsqreg_options}{...}
{synopthdr :bsqreg_options}
{synoptline}
{syntab :Model}
{synopt :{opt q:uantile(#)}}estimate {it:#} quantile; default is {cmd:quantile(.5)}{p_end}
{synopt :{opt r:eps(#)}}perform {it:#} bootstrap replications; default is {cmd:reps(20)}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help qreg##bsqreg_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synoptline}
{p2colreset}{...}


INCLUDE help fvvarlist
{phang}{cmd:by}, {cmd:mi estimate}, {cmd:rolling}, and {cmd:statsby}
are allowed with {cmd:qreg}, {cmd:iqreg}, {cmd:sqreg}, and {cmd:bsqreg};
{opt mfp}, {cmd:nestreg}, and
{cmd:stepwise} are allowed with {cmd:qreg}; see {help prefix}.{p_end}
{marker weight}{...}
{phang}{cmd:qreg} allows {cmd:fweight}s, {cmd:iweight}s, and
{cmd:pweight}s; see {help weight}.{p_end}
{phang}See {manhelp qreg_postestimation R:qreg postestimation} for features
available after estimation.


{marker menu}{...}
{title:Menu}

    {title:qreg}

{phang2}
{bf:Statistics > Nonparametric analysis > Quantile regression}

    {title:iqreg}

{phang2}
{bf:Statistics > Nonparametric analysis > Interquantile regression}

    {title:sqreg}

{phang2}
{bf:Statistics > Nonparametric analysis > Simultaneous-quantile regression}

    {title:bsqreg}

{phang2}
{bf:Statistics > Nonparametric analysis > Bootstrapped quantile regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:qreg} fits quantile (including median) regression models, also known as
least-absolute-value models (LAV or MAD) and minimum L1-norm models.
The quantile regression models fit by {cmd:qreg} express the quantiles
of the conditional distribution as linear functions of the independent
variables.

{pstd}
{cmd:iqreg} estimates interquantile range regressions, regressions of the
difference in quantiles.  The estimated variance-covariance matrix of the
estimators (VCE) is obtained via bootstrapping.

{pstd}
{cmd:sqreg} estimates simultaneous-quantile regression.  It produces the same
coefficients as {cmd:qreg} for each quantile.  Reported standard errors will
be similar, but {cmd:sqreg} obtains an estimate of the VCE via bootstrapping,
and the VCE includes between-quantile blocks.  Thus you can test and construct
confidence intervals comparing coefficients describing different quantiles.

{pstd}
{cmd:bsqreg} is equivalent to {cmd:sqreg} with one quantile.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R qregQuickstart:Quick start}

        {mansection R qregRemarksandexamples:Remarks and examples}

        {mansection R qregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_qreg}{...}
{title:Options for qreg}

{dlgtab:Model}

{phang}{opt quantile(#)} specifies the quantile to be estimated and should be
a number between 0 and 1, exclusive.  Numbers larger than 1 are interpreted as
percentages.  The default value of 0.5 corresponds to the median.

{dlgtab:SE/Robust}

{phang}{cmd:vce(}[{it:vcetype}]{cmd:,} [{it:vceopts}]{cmd:)}
specifies the type of VCE to compute and the density estimation method to use
in computing the VCE.

{phang2}
{it:vcetype} specifies the type of VCE to compute.  Available types are
{cmd:iid} and {cmd:robust}.

{phang3}
{cmd:vce(iid)}, the default, computes the VCE under the assumption that the
residuals are independent and identically distributed (i.i.d.).

{phang3}
{cmd:vce(robust)} computes the robust VCE under the assumption that the
residual density is continuous and bounded away from 0 and infinity
at the specified {cmd:quantile()}; see
{help qreg##K2005:Koenker (2005, sec. 4.2)}.

{phang2}
{it:vceopts} consists of available {it:denmethod} and {it:bwidth} options.

{phang3}
{it:denmethod} specifies the method to use for the nonparametric density
estimator.  Available methods are {cmd:fitted}, {cmd:residual}, or
{cmd:kernel}[{cmd:(}{it:kernel}{cmd:)}], where the optional {it:kernel} must 
be one of the kernel choices listed below.

{p 16 20 2}{cmd:fitted} and {cmd:residual} specify that the nonparametric
density estimator use some of the structure imposed by quantile regression.
The default {cmd:fitted} uses a function of the fitted values and
{cmd:residual} uses a function of the residuals.  {cmd:vce(robust, residual)}
is not allowed.

{p 16 20 2}{cmd:kernel()} specifies that the nonparametric density estimator
use a kernel method.  The available kernel functions are {cmd:epanechnikov},
{cmd:epan2}, {cmd:biweight}, {cmd:cosine}, {cmd:gaussian}, {cmd:parzen},
{cmd:rectangle}, and {cmd:triangle}.  The default is {cmd:epanechnikov}.  See
{manlink R kdensity} for the kernel function forms.

{phang3}
{it:bwidth} specifies the bandwidth method to use by the nonparametric
density estimator.  Available methods are {cmd:hsheather} for the
Hall-Sheather bandwidth, {cmd:bofinger} for the Bofinger bandwidth,
and {cmd:chamberlain} for the Chamberlain bandwidth.

{pmore2}See {help qreg##K2005:Koenker (2005, sec. 3.4 and 4.10)} for
a description of the sparsity estimation techniques and the Hall-Sheather and
Bofinger bandwidth formulas.  See
{help qreg##C1994:Chamberlain (1994, eq. 2.2)}
for the Chamberlain bandwidth.

{dlgtab:Reporting}

{phang}{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{marker qreg_display_options}{...}
INCLUDE help displayopts_list

{marker qreg_optimize}{...}
{dlgtab:Optimization}

{phang}{it:optimization_options}: {opt iter:ate(#)}, [{cmd:no}]{opt log}, 
{opt tr:ace}.  {opt iterate()} specifies the maximum number of iterations;
{opt log}/{opt nolog} specifies whether to show the iteration log
(see {cmd:set iterlog} in {manhelpi set_iter R:set iter}); and
{opt trace} specifies that the iteration log should include the current
parameter vector.  These options are seldom used.

{phang}{opt wlsiter(#)} specifies the number of weighted least-squares
iterations that will be attempted before the linear programming iterations are
started.  The default value is 1.  If there are convergence 
problems, increasing this number should help.


{marker options_iqreg}{...}
{title:Options for iqreg}

{dlgtab:Model}

{phang}{opt quantiles(# #)} specifies the quantiles to be compared.  The first
number must be less than the second, and both should be between 0 and 1,
exclusive.  Numbers larger than 1 are interpreted as percentages.  Not
specifying this option is equivalent to specifying 
{bind:{cmd:quantiles(.25 .75)}}, meaning the interquantile range.

{phang}{opt reps(#)} specifies the number of bootstrap replications to be used
to obtain an estimate of the variance-covariance matrix of the estimators
(standard errors).  {cmd:reps(20)} is the default and is arguably too small.
{cmd:reps(100)} would perform 100 bootstrap replications.  {cmd:reps(1000)}
would perform 1,000 replications.

{dlgtab:Reporting}

{phang}{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}{opt nodots} suppresses display of the replication dots.

{marker iqreg_display_options}{...}
INCLUDE help displayopts_list


{marker options_sqreg}{...}
{title:Options for sqreg}

{dlgtab:Model}

{phang}{cmd:quantiles(}{it:#} [{it:#} [{it:#} {it:...}]]{cmd:)} specifies the
quantiles to be estimated and should contain numbers between 0 and 1,
exclusive.  Numbers larger than 1 are interpreted as percentages.  The default
value of 0.5 corresponds to the median.

{phang}{opt reps(#)} specifies the number of bootstrap replications to be used
to obtain an estimate of the variance-covariance matrix of the estimators
(standard errors).  {cmd:reps(20)} is the default and is arguably too small.
{cmd:reps(100)} would perform 100 bootstrap replications.  {cmd:reps(1000)}
would perform 1,000 replications.

{dlgtab:Reporting}

{phang}{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}{opt nodots} suppresses display of the replication dots.

{marker sqreg_display_options}{...}
INCLUDE help displayopts_list


{marker options_bsqreg}{...}
{title:Options for bsqreg}

{dlgtab:Model}

{phang}{opt quantile(#)} specifies the quantile to be estimated and should be
a number between 0 and 1, exclusive.  Numbers larger than 1 are interpreted as
percentages.  The default value of 0.5 corresponds to the median.

{phang}{opt reps(#)} specifies the number of bootstrap replications to be used
to obtain an estimate of the variance-covariance matrix of the estimators
(standard errors).  {cmd:reps(20)} is the default and is arguably too small.
{cmd:reps(100)} would perform 100 bootstrap replications.  {cmd:reps(1000)}
would perform 1,000 replications.

{dlgtab:Reporting}

{phang}{opt level(#)}; 
{helpb estimation options##level():[R] Estimation options}.

{marker bsqreg_display_options}{...}
INCLUDE help displayopts_list


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Median regression{p_end}
{phang2}{cmd:. qreg price weight length foreign}{p_end}

{pstd}Replay results{p_end}
{phang2}{cmd:. qreg}

{pstd}Estimate .25 quantile using the Bofinger bandwidth method{p_end}
{phang2}{cmd:. qreg price weight length foreign, quantile(.25) vce(iid, bofinger)}
{p_end}

{pstd}Estimate .75 quantile using the Parzen kernel density estimator and
the Chamberlain bandwidth method{p_end}
{phang2}{cmd:. qreg price weight length foreign, quantile(.75)}
{cmd: vce(iid, kernel(parzen) chamberlain)}{p_end}

{pstd}Estimate [.25, .75] interquantile range, performing 100 bootstrap
replications{p_end}
{phang2}{cmd:. iqreg price weight length foreign, quantile(.25 .75) reps(100)}
{p_end}

{pstd}Same as above{p_end}
{phang2}{cmd:. iqreg price weight length foreign, reps(100)}

{pstd}Estimate .25, .5, and .75 quantiles simultaneously, performing 100
bootstrap replications{p_end}
{phang2}{cmd:. sqreg price weight length foreign, quantile(.25 .5 .75) reps(100)}
{p_end}

{pstd}Median regression with bootstrap standard errors{p_end}
{phang2}{cmd:. bsqreg price weight length foreign}{p_end}

{pstd}Estimate .75 quantile with bootstrap standard errors{p_end}
{phang2}{cmd:. bsqreg price weight length foreign, quantile(.75)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:qreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(q)}}quantile requested{p_end}
{synopt:{cmd:e(q_v)}}value of the quantile{p_end}
{synopt:{cmd:e(sum_adev)}}sum of absolute deviations{p_end}
{synopt:{cmd:e(sum_rdev)}}sum of raw deviations{p_end}
{synopt:{cmd:e(sum_w)}}sum of weights{p_end}
{synopt:{cmd:e(f_r)}}density estimate{p_end}
{synopt:{cmd:e(sparsity)}}sparsity estimate{p_end}
{synopt:{cmd:e(bwidth)}}bandwidth{p_end}
{synopt:{cmd:e(kbwidth)}}kernel bandwidth
{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(convcode)}}{cmd:0} if converged; otherwise, return code for why
nonconvergence{p_end}

{p2col 5 20 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:qreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(bwmethod)}}bandwidth method; {cmd:hsheather}, {cmd:bofinger},
or {cmd:chamberlain}{p_end}
{synopt:{cmd:e(denmethod)}}density estimation method; {cmd:fitted},
{cmd:residual}, or {cmd:kernel}{p_end}
{synopt:{cmd:e(kernel)}}kernel function{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:iqreg} stores the following in {cmd:e()}:

{p2col 5 20 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(q0)}}lower quantile requested{p_end}
{synopt:{cmd:e(q1)}}upper quantile requested{p_end}
{synopt:{cmd:e(reps)}}number of replications{p_end}
{synopt:{cmd:e(sumrdev0)}}lower quantile sum of raw deviations{p_end}
{synopt:{cmd:e(sumrdev1)}}upper quantile sum of raw deviations{p_end}
{synopt:{cmd:e(sumadev0)}}lower quantile sum of absolute deviations{p_end}
{synopt:{cmd:e(sumadev1)}}upper quantile sum of absolute deviations{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(convcode)}}{cmd:0} if converged; otherwise, return code for why
nonconvergence{p_end}

{p2col 5 20 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:iqreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:sqreg} stores the following in {cmd:e()}:

{p2col 5 20 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(n_q)}}number of quantiles requested{p_end}
{synopt:{cmd:e(q}{it:#}{cmd:)}}the quantiles requested{p_end}
{synopt:{cmd:e(reps)}}number of replications{p_end}
{synopt:{cmd:e(sumrdv}{it:#}{cmd:)}}sum of raw deviations for q{it:#}{p_end}
{synopt:{cmd:e(sumadv}{it:#}{cmd:)}}sum of absolute deviations for q{it:#}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(convcode)}}{cmd:0} if converged; otherwise, return code for why
nonconvergence{p_end}

{p2col 5 20 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:sqreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:bsqreg} stores the following in {cmd:e()}:

{p2col 5 20 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(q)}}quantile requested{p_end}
{synopt:{cmd:e(q_v)}}value of the quantile{p_end}
{synopt:{cmd:e(reps)}}number of replications{p_end}
{synopt:{cmd:e(sum_adev)}}sum of absolute deviations{p_end}
{synopt:{cmd:e(sum_rdev)}}sum of raw deviations{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(convcode)}}{cmd:0} if converged; otherwise, return code for why
nonconvergence{p_end}

{p2col 5 20 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:bsqreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker C1994}{...}
{phang}
Chamberlain, G. 1994. Quantile regression, censoring, and the 
structure of wages. In {it:Advances in Economics Sixth World Congress}, 
ed. Christopher A. Sims, 171-209. Cambridge University Press: Cambridge.

{marker K2005}{...}
{phang}
Koenker, R. 2005. {it:Quantile Regression}. Cambridge University Press:
New York.
{p_end}
