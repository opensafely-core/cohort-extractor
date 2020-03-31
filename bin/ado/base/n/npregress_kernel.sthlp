{smcl}
{* *! version 1.1.0  27feb2019}{...}
{viewerdialog "npregress kernel" "dialog npregress_kernel"}{...}
{vieweralsosee "[R] npregress kernel" "mansection R npregresskernel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress kernel postestimation" "help npregress kernel postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress intro" "mansection R npregressintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{viewerjumpto "Syntax" "npregress kernel##syntax"}{...}
{viewerjumpto "Menu" "npregress kernel##menu"}{...}
{viewerjumpto "Description" "npregress kernel##description"}{...}
{viewerjumpto "Links to PDF documentation" "npregress kernel##linkspdf"}{...}
{viewerjumpto "Options" "npregress kernel##options"}{...}
{viewerjumpto "Examples" "npregress kernel##examples"}{...}
{viewerjumpto "Stored results" "npregress kernel##results"}{...}
{viewerjumpto "Reference" "npregress kernel##reference"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[R] npregress kernel} {hline 2}}Nonparametric kernel regression{p_end}
{p2col:}({mansection R npregresskernel:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:npregress} {cmd:kernel}  
{depvar}
{indepvars} {ifin}
[{cmd:,} {it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmd:estimator(linear}|{cmd:constant)}}use the local-linear or local-constant kernel estimator{p_end}
{synopt :{opth kern:el(npregress kernel##kernel:kernel)}}kernel density function for continuous covariates{p_end}
{synopt :{opth dkern:el(npregress kernel##dkernel:dkernel)}}kernel density function for discrete covariates{p_end}
{synopt :{opth predict:(npregress kernel##prspec:prspec)}}store predicted values of the mean and derivatives using variable names specified in {it:prspec}{p_end}
{synopt :{opt noderiv:atives}}suppress derivative computation{p_end}
{synopt :{opt imaic}}use improved AIC instead of cross-validation to compute optimal bandwidth{p_end}
{synopt :{opth unid:entsample(newvar)}}specify name of variable that marks identification problems{p_end}

{syntab:Bandwidth}
{synopt :{opth bw:idth(npregress kernel##specs:specs)}}specify kernel bandwidth for all predictions{p_end}
{synopt :{opth meanbw:idth(npregress kernel##specs:specs)}}specify kernel bandwidth for the mean{p_end}
{synopt :{opth derivbw:idth(npregress kernel##specs:specs)}}specify kernel bandwidth for the derivatives{p_end}

{syntab:SE}
{p2coldent:* {opth vce(vcetype)}}{it:vcetype} may be {opt none} or {opt boot:strap}{p_end}
{synopt :{opt r:eps(#)}}equivalent to {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}{p_end}
{synopt :{opt seed(#)}}set random-number seed to {it:#}; must also specify
{opt reps(#)}{p_end}
{synopt :{opt bwreplace}}vary bandwidth with each bootstrap replication;
seldom used{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help npregress kernel##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall
{synopt :{opth citype:(npregress kernel##citype:citype)}}method to
compute bootstrap confidence intervals; default is
{cmd:citype(}{cmdab:p:ercentile}{cmd:)}{p_end}

{syntab:Maximization}
{synopt:{it:{help npregress kernel##maximize_options:maximize_options}}}control the maximization process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help fvvarlist
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, and {cmd:jackknife} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
* {cmd:vce(bootstrap)} reports percentile confidence intervals instead of the
normal-based confidence intervals reported when {cmd:vce(bootstrap)} is
specified with other estimation commands.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp npregress_kernel_postestimation R:npregress kernel postestimation} for features available after estimation.{p_end}

{marker kernel}{...}
{synoptset 27}{...}
{synopthdr:kernel}
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

{marker dkernel}{...}
{synoptset 27}{...}
{synopthdr:dkernel}
{synoptline}
{synopt :{opt li:racine}}Li-Racine kernel function; the default{p_end}
{synopt :{opt cell:mean}}cell means kernel function{p_end}
{synoptline}

{synoptset 19}{...}
{marker citype}{...}
{synopthdr:citype}
{synoptline}
{synopt :{opt p:ercentile}}percentile confidence intervals; the default{p_end}
{synopt :{opt bc}}bias-corrected confidence intervals{p_end}
{synopt :{opt nor:mal}}normal-based confidence intervals{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Nonparametric kernel regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:npregress kernel} performs nonparametric local-linear and local-constant
kernel regression.  Like linear regression, nonparametric regression models
the mean of the outcome conditional on the covariates, but unlike linear
regression, it makes no assumptions about the functional form of the
relationship between the outcome and the covariates.  {cmd:npregress kernel}
may be used to model the mean of a continuous, count, or binary outcome.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R npregresskernelQuickstart:Quick start}

        {mansection R npregresskernelRemarksandexamples:Remarks and examples}

        {mansection R npregresskernelMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:estimator(linear}|{cmd:constant)} specifies whether the local-constant or
local-linear kernel estimator should be used.  The default is
{cmd:estimator(linear)}.

{phang}
{opth kernel:(npregress kernel##kernel:kernel)} specifies the kernel density
function for continuous covariates for use in calculating the local-constant
or local-linear estimator.  The default is {cmd:kernel(epanechnikov)}.

{phang}
{opth dkernel:(npregress kernel##dkernel:dkernel)} specifies the kernel density
function for discrete covariates for use in calculating the local-constant or
local-linear estimator.  The default is {cmd:dkernel(liracine)}; see
{mansection R npregresskernelMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] npregress kernel} for details on the Li-Racine kernel.  When
{cmd:dkernel(cellmean)} is specified, discrete covariates are weighted by
their cell means.

{marker prspec}{...}
{phang}
{opt predict(prspec)} specifies that {cmd:npregress kernel} store the
predicted values for the mean and derivatives of the mean with the specified
names.  {it:prspec} is the following:

{phang2}
{cmd:predict(}{varlist} {c |} {it:{help newvarlist##stub*:stub}}{cmd:*} [{cmd:, replace noderivatives}]{cmd:)}

{pmore}
The option takes a variable list or a {it:stub}.  The first variable name
corresponds to the predicted outcome mean. The second name corresponds to the
derivatives of the mean.  There is one derivative for each {it:indepvar}.

{pmore}
When {cmd:replace} is used, variables with the names in {it:varlist} or
{it:stub}{cmd:*} are replaced by those in the new computation.  If
{cmd:noderivatives} is specified, only a variable for the mean
is created.  This will increase computation speed but will add to the
computation burden if you want to obtain marginal effects after estimation.

{phang}
{cmd:noderivatives} suppresses the computation of the derivatives.  In this
case, only the mean function is computed.

{phang}
{cmd:imaic} specifies to use the improved AIC instead of cross-validation to
compute optimal bandwidths.

{phang}
{opth unidentsample(newvar)} specifies the name of a variable that is 1 if the
observation violates the model identification assumptions and is 0 otherwise.
By default, this variable is a system variable ({cmd:_unident_sample}).
 
{pmore}
{cmd:npregress kernel} computes a weighted regression for each observation in
our data.  An observation violates identification assumptions if the
regression cannot be performed at that point.  The regression formula, which
is discussed in detail in
{mansection R npregresskernelMethodsandformulas:{it:Methods and formulas}},
is given by

{pmore2}
gamma = ({bf:Z}'{bf:W}{bf:Z})^{-1}{bf:Z}'{bf:W}{bf:y}

{pmore}
{cmd:npregress kernel} verifies that the matrix ({bf:Z}'{bf:W}{bf:Z})
is full rank for each observation to determine identification.
Identification problems commonly arise when the bandwidth is
too small, resulting in too few observations within a bandwidth.
Independent variables that are collinear within the bandwidth
can also cause a problem with identification at that point.

{pmore}
Observations that violate identification assumptions are reported as missing
for the predicted means and derivatives.

{dlgtab:Bandwidth}

{marker bwidth}{...}
{marker specs}{...}
{phang}
{opt bwidth(specs)} specifies the half-width of the kernel at each point for
the computation of the mean and the derivatives of the mean function.  If no
bandwidth is specified, one is chosen by minimizing the integrated mean
squared error of the prediction.

{pmore}
{it:specs} specifies bandwidths for the mean and derivative 
for each {it:indepvar} in one of three ways: by specifying the name of a vector
containing the bandwidths (for example, {cmd:bwidth(H)}, where {cmd:H} is a
properly labeled vector); by specifying the equation and coefficient names
with the corresponding values (for example,
{cmd:bwidth(Mean:x1=0.5 Effect:x1=0.9)}); or by specifying a
list of values for the means, standard errors, and derivatives for {indepvars}
given in the order of the corresponding {it:indepvars} and specifying the
{cmd:copy} suboption (for example, {cmd:bwidth(0.5 0.9, copy)}).

{phang2}
{opt skip} specifies that any parameters found in the specified 
vector that are not also found in the model be ignored.  The default action is
to issue an error message.

{phang2}
{cmd:copy} specifies that the list of values or the vector 
be copied into the bandwidth vector by position rather than by name.

{phang}
{opth meanbwidth:(npregress kernel##specs:specs)} specifies the half-width of
the kernel at each point for the computation of the mean function.  If no
bandwidth is specified, one is chosen by minimizing the integrated mean
squared error of the prediction.  For details on how to specify the bandwidth,
see the description of {cmd:bwidth()}, {help npregress kernel##bwidth:above}.

{phang}
{opth derivbwidth:(npregress kernel##specs:specs)} specifies the half-width of
the kernel at each point for the computation of the derivatives of the mean.
If no bandwidth is specified, one is chosen by minimizing the integrated mean
squared error of the prediction.  For details on how to specify the bandwidth,
see the description of {cmd:bwidth()}, {help npregress kernel##bwidth:above}.

{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
may be either that no standard errors are reported ({cmd:none}; the default)
or that bootstrap standard errors are reported ({cmd:bootstrap}); see
{manhelpi vce_option R}.

{pmore}
We recommend that you select the number
of replications using {opt reps(#)} instead of specifying
{cmd:vce(bootstrap)}, which defaults to 50 replications. Be aware
that the number of replications needed to produce good estimates of
the standard errors varies depending on the problem.

{pmore}
When {cmd:vce(bootstrap)} is specified, {cmd:npregress kernel} reports
percentile confidence intervals as recommended by
{help npregress kernel##CJ2018:Cattaneo and Jansson (2018)} instead of
reporting the normal-based confidence intervals that are reported when
{cmd:vce(bootstrap)} is specified with other commands. Other types of
confidence intervals can be obtained by using the
{help npregress kernel##citype_ds:{bf:citype(}{it:citype}{bf:)}} option.

{phang}
{opt reps(#)} specifies the
number of bootstrap replications to be performed.
Specifying this option is equivalent to
specifying {cmd:vce(bootstrap, reps(}{it:#}{cmd:))}.

{phang}
{opt seed(#)} sets the random-number seed.
You must specify {opt reps(#)} with {opt seed(#)}.

{phang}
{opt bwreplace} computes a different bandwidth for each bootstrap replication.
The default is to compute the bandwidth once and keep it fixed for each
bootstrap replication.  This option is seldom used.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {cmd:nocnsreport}; see
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_list

{marker citype_ds}{...}
{phang}
{opt citype(citype)} specifies the type of confidence interval to be computed.
By default, bootstrap percentile confidence intervals are reported as
recommended by {help npregress kernel##CJ2018:Cattaneo and Jansson (2018)}.
{it:citype} may be one of {cmd:percentile}, {cmd:bc}, or {cmd:normal}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace}
{opt showstep},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following option is available with {cmd:npregress kernel} but is not shown
in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dui}

{pstd}Nonparametric kernel regression of {cmd:citations} as a function of
{cmd:fines}{p_end}
{phang2}{cmd:. npregress kernel citations fines}

{pstd}Same as above, but specify variable names for the mean and derivatives 
{p_end}
{phang2}{cmd:. npregress kernel citations fines, predict(mean deriv)}{p_end}

{pstd}Use the Gaussian kernel density function{p_end}
{phang2}{cmd:. npregress kernel citations fines, kernel(gaussian)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:npregress kernel} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mean)}}mean of mean function{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(nh)}}expected kernel observations{p_end}
{synopt:{cmd:e(converged_effect)}}{cmd:1} if effect optimization converged,
{cmd:0} otherwise{p_end}
{synopt:{cmd:e(converged_mean)}}{cmd:1} if mean optimization converged,
{cmd:0} otherwise{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if effect and mean optimization converged, {cmd:0} otherwise{p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:npregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(estimator)}}{cmd:linear} or {cmd:constant}{p_end}
{synopt:{cmd:e(kname)}}name of continuous kernel{p_end}
{synopt:{cmd:e(dkname)}}name of discrete kernel{p_end}
{synopt:{cmd:e(bselector)}}criterion function for bandwidth selection{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b} (or {cmd:b V} if {cmd:reps()} specified){p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsprop)}}signals to the {cmd:margins} command{p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(bwidth)}}bandwidth for all predictions{p_end}
{synopt:{cmd:e(derivbwidth)}}bandwidth for the derivative{p_end}
{synopt:{cmd:e(meanbwidth)}}bandwidth for the mean{p_end}
{synopt:{cmd:e(ilog_mean)}}iteration log for mean (up to 20 iterations){p_end}
{synopt:{cmd:e(ilog_effect)}}iteration log for effects (up to 20 iterations){p_end}

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker CJ2018}{...}
{phang}
Cattaneo, M. D., and M. Jansson. 2018. Kernel-based semiparametric estimators:
Small bandwidth asymptotics and bootstrap consistency.
{it:Econometrica} 86: 955-995.
{p_end}
