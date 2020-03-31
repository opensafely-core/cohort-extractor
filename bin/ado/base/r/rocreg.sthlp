{smcl}
{* *! version 1.3.1  12dec2018}{...}
{viewerdialog rocreg "dialog rocreg"}{...}
{vieweralsosee "[R] rocreg" "mansection R rocreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rocreg postestimation" "help rocreg postestimation"}{...}
{vieweralsosee "[R] rocregplot" "help rocregplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{vieweralsosee "[R] rocfit" "help rocfit"}{...}
{viewerjumpto "Syntax" "rocreg##syntax"}{...}
{viewerjumpto "Menu" "rocreg##menu"}{...}
{viewerjumpto "Description" "rocreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "rocreg##linkspdf"}{...}
{viewerjumpto "Options for nonparametric ROC estimation, using bootstrap" "rocreg##options_np"}{...}
{viewerjumpto "Options for parametric ROC estimation, using bootstrap" "rocreg##options_probit"}{...}
{viewerjumpto "Options for parametric ROC using maximum likelihood" "rocreg##options_probit_ml"}{...}
{viewerjumpto "Examples" "rocreg##examples"}{...}
{viewerjumpto "Stored results" "rocreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] rocreg} {hline 2}}Receiver operating characteristic (ROC) regression{p_end}
{p2col:}({mansection R rocreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Perform nonparametric analysis of ROC curve under covariates, using bootstrap

{p 8 16 2}
{cmd:rocreg}
{it:refvar}
{it:classvar}
[{it:classvars}]
{ifin}
[{cmd:,}
{it:{help rocreg##np_options:np_options}}]


{phang}
Perform parametric analysis of ROC curve under covariates, using bootstrap

{p 8 16 2}
{cmd:rocreg}
{it:refvar}
{it:classvar}
[{it:classvars}]
{ifin}
{cmd:, probit}
[{it:{help rocreg##probit_options:probit_options}}]


{phang}
Perform parametric analysis of ROC curve under covariates, using maximum
likelihood

{p 8 16 2}
{cmd:rocreg}
{it:refvar}
{it:classvar}
[{it:classvars}]
{ifin}
[{it:{help rocreg##weight:weight}}]
{cmd:, probit ml}
[{it:{help rocreg##probit_ml_options:probit_ml_options}}]


{marker np_options}{...}
{synoptset 30 tabbed}{...}
{synopthdr:np_options}
{synoptline}
{syntab:Model}
{synopt:{opt auc}}estimate total area under the ROC curve; the default{p_end}
{synopt:{cmd:roc(}{it:{help numlist}}{cmd:)}}estimate ROC for given
	false-positive rates{p_end}
{synopt:{cmd:invroc(}{it:{help numlist}}{cmd:)}}estimate false-positive rates
	for given ROC values{p_end}
{synopt:{cmd:pauc(}{it:{help numlist}}{cmd:)}}estimate partial area under the
	ROC curve (pAUC) up to each false-positive rate{p_end}
{synopt:{opth cl:uster(varname)}}variable identifying resampling clusters{p_end}
{synopt:{opth ctrlcov(varlist)}}adjust control distribution for covariates in {it:varlist}{p_end}
{synopt:{opt ctrlmod:el}({opt s:trata} | {opt l:inear})}stratify or regress on
	covariates; default is {cmd:ctrlmodel(strata)}{p_end}
{synopt:{cmd:pvc(}{opt e:mpirical} | {opt n:ormal}{cmd:)}}use empirical or
	normal distribution percentile value estimates; default is 
	{cmd:pvc(empirical)}{p_end}
{synopt:{opt tiec:orrected}}adjust for tied observations; not allowed with
{cmd:pvc(normal)} {p_end}

{syntab:Bootstrap}
{synopt:{opt noboot:strap}}do not perform bootstrap, just output point
	estimates {p_end}
{synopt:{opt bseed(#)}}random-number  seed for bootstrap {p_end}
{synopt:{opt brep:s(#)}}number of bootstrap replications; default is 
{cmd:breps(1000)} {p_end}
{synopt:{opt bootcc}}perform case-control (stratified on {it:refvar}) sampling
        rather than cohort sampling in bootstrap {p_end}
{synopt:{opt nobstr:ata}}ignore covariate stratification in bootstrap
	sampling {p_end}
{synopt:{opt nodots}}suppress bootstrap replication dots {p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}


{marker probit_options}{...}
{synoptset 30 tabbed}{...}
{synopthdr:probit_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt probit}}fit the probit model{p_end}
{synopt:{opth roccov(varlist)}}covariates affecting ROC curve{p_end}
{synopt:{opt fprpts(#)}}number of false-positive rate points to use in
	fitting ROC curve; default is {cmd:fprpts(10)} {p_end}
{synopt:{opt ctrlfpr:all}}fit ROC curve at each false-positive rate in
	control population {p_end}
{synopt:{opth cl:uster(varname)}}variable identifying resampling clusters{p_end}
{synopt:{opth ctrlcov(varlist)}}adjust control distribution for covariates in
        {it:varlist}{p_end}
{synopt:{opt ctrlmod:el}({opt s:trata} | {opt l:inear})}stratify or regress on
	covariates; default is {cmd:ctrlmodel(strata)}{p_end}
{synopt:{cmd:pvc(}{opt e:mpirical} | {opt n:ormal}{cmd:)}}use empirical or
	normal distribution percentile value estimates; default is 
	{cmd:pvc(empirical)}{p_end}
{synopt:{opt tiec:orrected}}adjust for tied observations; not allowed with
{cmd:pvc(normal)} {p_end}

{syntab:Bootstrap}
{synopt:{opt noboot:strap}}do not perform bootstrap, just output point
	estimates {p_end}
{synopt:{opt bseed(#)}}random-number  seed for bootstrap {p_end}
{synopt:{opt brep:s(#)}}number of bootstrap replications; default is 
{cmd:breps(1000)} {p_end}
{synopt:{opt bootcc}}perform case-control (stratified on {it:refvar}) sampling
        rather than cohort sampling in bootstrap {p_end}
{synopt:{opt nobstr:ata}}ignore covariate stratification in bootstrap
	sampling {p_end}
{synopt:{opt nodots}}suppress bootstrap replication dots {p_end}
{synopt: {cmd:bsave(}{it:{help filename}}{cmd:,} ...{cmd:)}}save bootstrap
   replicates from parametric estimation{p_end}
{synopt: {opth bfile(filename)}}use bootstrap replicates dataset for estimation replay{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {cmd:probit} is required.


{marker probit_ml_options}{...}
{synoptset 30 tabbed}{...}
{synopthdr:probit_ml_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt probit}}fit the probit model{p_end}
{p2coldent:* {opt ml}}fit the probit model by maximum likelihood estimation{p_end}
{synopt:{opth roccov(varlist)}}covariates affecting ROC curve{p_end}
{synopt:{opth cl:uster(varname)}}variable identifying clusters{p_end}
{synopt:{opth ctrlcov(varlist)}}adjust control distribution for covariates in
        {it:varlist} {p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help rocreg##display_options:display_options}}}control column formats, line width, and display of omitted variables{p_end}

{syntab:Maximization}
{synopt:{it:{help rocreg##maximize_options:maximize_options}}}control
	the maximization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {cmd:probit} and {cmd:ml} are required.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed with 
maximum likelihood estimation; see {help weight}.
{p_end}


{p 4 6 2}See {manhelp rocreg_postestimation R:rocreg postestimation} for
features available after estimation.{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > ROC analysis >}
           {bf:ROC regression models}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:rocreg} command is used to perform receiver operating characteristic
(ROC) analyses with rating and discrete classification data under the presence
of covariates.

{pstd}
The two variables {it:refvar} and {it:classvar} must be numeric. The reference
variable indicates the true state of the observation -- such as diseased and
nondiseased or normal and abnormal -- and must be coded as {opt 0} and
{opt 1}.  The {it:refvar} coded as {opt 0} can also be called the control
population, while the {it:refvar} coded as {opt 1} comprises the case
population.  The rating or outcome of the diagnostic test or test modality is
recorded in {it:classvar}, which must be at least ordinal, with higher values
indicating higher risk.

{pstd}
{cmd:rocreg} can fit three models: a nonparametric model, a parametric probit
model that uses the bootstrap for inference, and a parametric probit model fit
using maximum likelihood.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rocregQuickstart:Quick start}

        {mansection R rocregRemarksandexamples:Remarks and examples}

        {mansection R rocregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_np}{...}
{title:Options for nonparametric ROC estimation, using bootstrap}

{dlgtab:Model}

{phang} 
{opt auc} estimates the total area under the ROC curve.  This is the default
summary statistic.

{phang}
{opth roc:(numlist:numlist)} estimates the ROC corresponding to each of the
false-positive rates in {it:numlist}.  The values of {it:numlist} must be in
the range (0,1).

{phang}
{opth invroc:(numlist:numlist)} estimates the false-positive rates
corresponding to each of the ROC values in {it:numlist}.  The values of
{it:numlist} must be in the range (0,1).

{phang}
{opth pauc:(numlist:numlist)} estimates the partial area under the ROC curve
up to each false-positive rate in {it:numlist}.  The values of {it:numlist}
must be in the range (0,1].

{phang}
{opth cluster(varname)} specifies the variable identifying resampling clusters.

{phang}
{opth ctrlcov(varlist)} specifies the covariates to be used to adjust the
control population.

{phang}
{cmd:ctrlmodel(strata} | {cmd:linear)} specifies how to model the control
population of classifiers on {opt ctrlcov()}.  When {cmd:ctrlmodel(linear)} is
specified, linear regression is used.  The default is {cmd:ctrlmodel(strata)};
that is, the control population of classifiers is stratified on the control
variables.

{phang}
{cmd:pvc(empirical} | {cmd:normal)} determines how the percentile values of
the control population will be calculated.  When {cmd:pvc(normal)} is
specified, the standard normal cumulative distribution function (CDF) is used
for calculation.  Specifying {cmd:pvc(empirical)} will use the empirical CDFs
of the control population classifiers for calculation.  The default is
{cmd:pvc(empirical)}.

{phang}
{opt tiecorrected} adjusts the percentile values for ties.  For each value of
the classifier, one half the probability that the classifier equals that value
under the control population is added to the percentile value.  
{opt tiecorrected} is not allowed with {cmd:pvc(normal)}.

{dlgtab:Bootstrap}

{phang}
{opt nobootstrap} specifies that bootstrap standard errors not be calculated.

{phang}
{opt bseed(#)} specifies the random-number seed to be used in the bootstrap.

{phang}
{opt breps(#)} sets the number of bootstrap replications. The default is 
{cmd:breps(1000)}.

{phang}
{opt bootcc} performs case-control (stratified on {it:refvar}) sampling
rather than cohort bootstrap sampling.

{phang}
{opt nobstrata} ignores covariate stratification in bootstrap sampling.

{phang}
{opt nodots} suppresses bootstrap replication dots.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.


{marker options_probit}{...}
{title:Options for parametric ROC estimation, using bootstrap}

{dlgtab:Model}

{phang}
{opt probit} fits the  probit model.  This option is required and implies
parametric estimation.

{phang}
{opth roccov(varlist)} specifies the covariates that will affect the ROC curve.

{phang}
{opt fprpts(#)} sets the number of false-positive rate points to use in
modeling the ROC curve.  These points form an equispaced grid on (0,1).  The
default is {cmd:fprpts(10)}.

{phang}
{opt ctrlfprall} models the ROC curve at each false-positive rate in
the control population.

{phang}
{opth cluster(varname)} specifies the variable identifying resampling clusters.

{phang}
{opth ctrlcov(varlist)} specifies the covariates to be used to adjust the
control population.

{phang}
{cmd:ctrlmodel(strata} | {cmd:linear)} specifies how to model the control
population of classifiers on {opt ctrlcov()}.  When {cmd:ctrlmodel(linear)} is
specified, linear regression is used.  The default is {cmd:ctrlmodel(strata)};
that is, the control population of classifiers is stratified on the control
variables.

{phang}
{cmd:pvc(empirical} | {cmd:normal)} determines how the percentile values of
the control population will be calculated.  When {cmd:pvc(normal)} is
specified, the standard normal CDF is used for calculation.  Specifying
{cmd:pvc(empirical)} will use the empirical CDFs of the control population
classifiers for calculation.  The default is {cmd:pvc(empirical)}.

{phang}
{opt tiecorrected} adjusts the percentile values for ties.  For each value of
the classifier, one half the probability that the classifier equals that value
under the control population is added to the percentile value.
{cmd:tiecorrected} is not allowed with {cmd:pvc(normal)}.

{dlgtab:Bootstrap}

{phang}
{opt nobootstrap} specifies that bootstrap standard errors not be calculated.

{phang}
{opt bseed(#)} specifies the random-number seed to be used in the bootstrap.

{phang}
{opt breps(#)} sets the number of bootstrap replications. The default is 
{cmd:breps(1000)}.

{phang}
{opt bootcc} performs case-control (stratified on {it:refvar}) sampling
rather than cohort bootstrap sampling.

{phang}
{opt nobstrata} ignores covariate stratification in bootstrap sampling.

{phang}
{opt nodots} suppresses bootstrap replication dots.

{phang}
{cmd:bsave(}{it:{help filename}}{cmd:,} ...{cmd:)} saves bootstrap replicates
from parametric estimation in the given {it:filename} with specified options
(that is, {cmd:replace}).  {cmd:bsave()} is only allowed with parametric
analysis using bootstrap. 

{phang}
{opth bfile(filename)} specifies to use the bootstrap replicates dataset
for estimation replay.  {cmd:bfile()} is only allowed with parametric analysis
using bootstrap. 

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.


{marker options_probit_ml}{...}
{title:Options for parametric ROC using maximum likelihood}

{dlgtab:Model}

{phang}
{opt probit} fits the probit model.  This option is required and implies
parametric estimation.

{phang}
{opt ml} fits the probit model by maximum likelihood estimation.
This option is required and must be specified with {opt probit}.

{phang}
{opth roccov(varlist)} specifies the covariates that will affect the ROC curve.

{phang}
{opth cluster(varname)} specifies the variable used for clustering.

{phang}
{opth ctrlcov(varlist)} specifies the covariates to be used to adjust the
control population.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.  The {cmd:technique(bhhh)} option is not
allowed.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hanley}{p_end}

{pstd}Fit a smooth ROC curve assuming a binormal model{p_end}
{phang2}{cmd:. rocreg disease rating, probit ml}{p_end}
{phang2}{cmd:. rocregplot}{p_end}

{pstd}Fit a nonparametric ROC curve{p_end}
{phang2}{cmd:. rocreg disease rating, bseed(32)}{p_end}
{phang2}{cmd:. rocregplot}{p_end}

    {hline}
{pstd}Setup of dataset with multiple covariates{p_end}
{phang2}{cmd:. webuse nnhs, clear}{p_end}

{pstd}Fit a binormal ROC curve to data with ROC (control) covariates and
bootstrap inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
        {cmd:roccov(currage) cluster(id) bseed(56930) breps(50) bsave(nnhs2y1)}
        {cmd:probit}{p_end}
{phang2}{cmd:. rocregplot, at1(currage=50) at2(currage=40) at3(currage=30)}
        {cmd:roc(.5) bfile(nnhs2y1)}{p_end}

{pstd}Fit a binormal ROC curve to data, with ROC covariates and
maximum likelihood inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
        {cmd:roccov(currage) cluster(id) probit ml}{p_end}
{phang2}{cmd:. rocregplot, at1(currage=50) at2(currage=40) at3(currage=30)}
        {cmd:roc(.5)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
Nonparametric {cmd:rocreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_strata)}}number of covariate strata{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(level)}}confidence level for bootstrap CIs{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rocreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(classvars)}}classification variable list{p_end}
{synopt:{cmd:e(refvar)}}status variable, reference variable{p_end}
{synopt:{cmd:e(ctrlmodel)}}covariate-adjustment specification{p_end}
{synopt:{cmd:e(ctrlcov)}}covariate-adjustment variables{p_end}
{synopt:{cmd:e(pvc)}}percentile value calculation method{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tiecorrected)}}{cmd:tiecorrected}, if specified{p_end}
{synopt:{cmd:e(nobootstrap)}}{cmd:nobootstrap}, if specified{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used in bootstrap, if bootstrap was performed{p_end}
{synopt:{cmd:e(breps)}}number of bootstrap resamples, if bootstrap performed{p_end}
{synopt:{cmd:e(bootcc)}}{cmd:bootcc}, if specified{p_end}
{synopt:{cmd:e(nobstrata)}}{cmd:nobstrata}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{synopt:{cmd:e(roc)}}false-positive rates where ROC was estimated{p_end}
{synopt:{cmd:e(invroc)}}ROC values where false-positive rates were estimated{p_end}
{synopt:{cmd:e(pauc)}}false-positive rates where pAUC was estimated{p_end}
{synopt:{cmd:e(auc)}}indicates that AUC was calculated{p_end}
{synopt:{cmd:e(vce)}}{cmd:bootstrap}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V} (or {cmd:b} if bootstrap not performed){p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(b_bs)}}bootstrap estimates{p_end}
{synopt:{cmd:e(reps)}}number of nonmissing results{p_end}
{synopt:{cmd:e(bias)}}estimated biases{p_end}
{synopt:{cmd:e(se)}}estimated standard errors{p_end}
{synopt:{cmd:e(z0)}}median biases{p_end}
{synopt:{cmd:e(ci_normal)}}normal-approximation confidence intervals{p_end}
{synopt:{cmd:e(ci_percentile)}}percentile confidence intervals{p_end}
{synopt:{cmd:e(ci_bc)}}bias-corrected confidence intervals{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
Parametric, bootstrap {cmd:rocreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_strata)}}number of covariate strata{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(level)}}confidence level for bootstrap CIs{p_end}
{synopt:{cmd:e(rank)}}number of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rocreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(classvars)}}classification variable list{p_end}
{synopt:{cmd:e(refvar)}}status variable, reference variable{p_end}
{synopt:{cmd:e(ctrlmodel)}}covariate-adjustment specification{p_end}
{synopt:{cmd:e(ctrlcov)}}covariate-adjustment variables{p_end}
{synopt:{cmd:e(pvc)}}percentile value calculation method{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tiecorrected)}}{cmd:tiecorrected}, if specified{p_end}
{synopt:{cmd:e(probit)}}{cmd:probit}, if specified{p_end}
{synopt:{cmd:e(roccov)}}ROC covariates{p_end}
{synopt:{cmd:e(fprpts)}}number of points used as false-positive rate fit points{p_end}
{synopt:{cmd:e(ctrlfprall)}}indicates whether all observed false-positive rates were used as fit points{p_end}
{synopt:{cmd:e(nobootstrap)}}{cmd:nobootstrap}, if specified{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used in bootstrap{p_end}
{synopt:{cmd:e(breps)}}number of bootstrap resamples{p_end}
{synopt:{cmd:e(bootcc)}}{cmd:bootcc}, if specified{p_end}
{synopt:{cmd:e(nobstrata)}}{cmd:nobstrata}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(exp}{it:#}{cmd:)}}expression for the {it:#}th statistic{p_end}
{synopt:{cmd:e(vce)}}{cmd:bootstrap}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V} (or {cmd:b} if {opt nobootstrap} is specified){p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(b_bs)}}bootstrap estimates{p_end}
{synopt:{cmd:e(reps)}}number of nonmissing results{p_end}
{synopt:{cmd:e(bias)}}estimated biases{p_end}
{synopt:{cmd:e(se)}}estimated standard errors{p_end}
{synopt:{cmd:e(z0)}}median biases{p_end}
{synopt:{cmd:e(ci_normal)}}normal-approximation confidence intervals{p_end}
{synopt:{cmd:e(ci_percentile)}}percentile confidence intervals{p_end}
{synopt:{cmd:e(ci_bc)}}bias-corrected confidence intervals{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
Parametric, maximum likelihood {cmd:rocreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rocreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(classvars)}}classification variable list{p_end}
{synopt:{cmd:e(refvar)}}status variable{p_end}
{synopt:{cmd:e(ctrlmodel)}}{cmd:linear}{p_end}
{synopt:{cmd:e(ctrlcov)}}control population covariates{p_end}
{synopt:{cmd:e(roccov)}}ROC covariates{p_end}
{synopt:{cmd:e(probit)}}{cmd:probit}, if specified{p_end}
{synopt:{cmd:e(pvc)}}{cmd:normal}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{cmd:cluster} if clustering used{p_end}
{synopt:{cmd:e(vcetype)}}{cmd:robust} if multiple classifiers or clustering used{p_end}
{synopt:{cmd:e(ml)}}{cmd:ml}, if specified{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}} marks estimation sample{p_end}
{p2colreset}{...}
