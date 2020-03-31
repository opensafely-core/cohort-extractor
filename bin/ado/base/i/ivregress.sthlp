{smcl}
{* *! version 1.3.13  03feb2020}{...}
{viewerdialog ivregress "dialog ivregress"}{...}
{viewerdialog "svy: ivregress" "dialog ivregress, message(-svy-) name(svy_ivregress)"}{...}
{vieweralsosee "[R] ivregress" "mansection R ivregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress postestimation" "help ivregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{vieweralsosee "[FMM] fmm: ivregress" "help fmm ivregress"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SP] spivregress" "help spivregress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[XT] xtivreg" "help xtivreg"}{...}
{viewerjumpto "Syntax" "ivregress##syntax"}{...}
{viewerjumpto "Menu" "ivregress##menu"}{...}
{viewerjumpto "Description" "ivregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivregress##linkspdf"}{...}
{viewerjumpto "Options" "ivregress##options"}{...}
{viewerjumpto "Examples" "ivregress##examples"}{...}
{viewerjumpto "Video example" "ivregress##video"}{...}
{viewerjumpto "Stored results" "ivregress##results"}{...}
{viewerjumpto "References" "ivregress##references"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] ivregress} {hline 2}}Single-equation instrumental-variables regression{p_end}
{p2col:}({mansection R ivregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:ivregress} {it:estimator} {depvar} [{it:{help varlist:varlist1}}]
{cmd:(}{it:{help varlist:varlist2}} {cmd:=}
        {it:{help varlist:varlist_iv}}{cmd:)} {ifin}
[{it:{help ivregress##weight:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:varlist1} is the list of exogenous variables.{p_end}

{phang}
{it:varlist2} is the list of endogenous variables.{p_end}

{phang}
{it:varlist_iv} is the list of exogenous variables used with {it:varlist1}
   as instruments for {it:varlist2}.

{synoptset 22}{...}
{synopthdr:estimator}
{synoptline}
{synopt:{opt 2sls}}two-stage least squares (2SLS){p_end}
{synopt:{opt liml}}limited-information maximum likelihood (LIML){p_end}
{synopt:{opt gmm}}generalized method of moments (GMM){p_end}
{synoptline}

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt h:ascons}}has user-supplied constant{p_end}

{p2col 3 4 4 2:# GMM}{p_end}
{synopt :{opt wmat:rix(wmtype)}}{it:wmtype} may be {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt hac} {help ivregress##kernel:{it:kernel}}, or {opt un:adjusted}{p_end}
{synopt :{opt c:enter}}center moments in weight matrix computation{p_end}
{synopt :{opt i:gmm}}use iterative instead of two-step GMM estimator{p_end}
{p2coldent:* {opt eps(#)}}specify # for parameter convergence criterion; default is {cmd:eps(1e-6)}{p_end}
{p2coldent:* {opt weps(#)}}specify # for weight matrix convergence criterion; default is {cmd:weps(1e-6)}{p_end}
{p2coldent:* {it:{help ivregress##optimization_options:optimization_options}}}control the optimization process; seldom used{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt un:adjusted},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
   {opt jack:knife}, or {opt hac} {help ivregress##kernel:{it:kernel}}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage regression{p_end}
{synopt :{opt small}}make degrees-of-freedom adjustments and report small-sample statistics{p_end}
{synopt :{opt nohe:ader}}display only the coefficient table{p_end}
{synopt :{opth dep:name(varname:depname)}}substitute dependent variable name{p_end}
{synopt :{opth ef:orm(strings:string)}}report exponentiated coefficients and use
{it:string} to label them{p_end}
{synopt :{it:{help ivregress##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{synopt :{opt per:fect}}do not check for collinearity between 
endogenous regressors and excluded instruments{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}# These options may be specified only when {cmd:gmm} is specified.{p_end}
{p 4 6 2}* These options may be specified only when {cmd:igmm} is specified.{p_end}
{p 4 6 2}{it:varlist1}, {it:varlist2}, and {it:varlist_iv} may 
contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:varlist1}, {it:varlist2}, and {it:varlist_iv} may 
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fmm}, {cmd:jackknife}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp fmm_ivregress FMM:fmm ivregress}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}{cmd:hascons}, {cmd:vce()}, {cmd:noheader},
{cmd:depname()}, and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s 
are allowed; see {help weight}.{p_end}
{p 4 6 2}{opt perfect} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp ivregress_postestimation R:ivregress postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Endogenous covariates >}
    {bf:Linear regression with endogenous covariates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ivregress} fits linear models where one or more of the regressors are
endogenously determined.  {cmd:ivregress} supports estimation via two-stage
least squares (2SLS), limited-information maximum likelihood (LIML), and
generalized method of moments (GMM).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivregressQuickstart:Quick start}

        {mansection R ivregressRemarksandexamples:Remarks and examples}

        {mansection R ivregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see 
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt hascons} indicates that a user-defined constant or its equivalent is
specified among the independent variables. 

{dlgtab:GMM}

{marker wmatrix}{...}
{phang}
{opt wmatrix(wmtype)} specifies the type of weighting matrix to be used 
in conjunction with the GMM estimator.

{pmore}
Specifying {cmd:wmatrix(robust)} requests a weighting matrix that is 
optimal when the error term is heteroskedastic.  {cmd:wmatrix(robust)} is the
default.

{pmore}
Specifying {cmd:wmatrix(cluster} {it:clustvar}{cmd:)} requests a 
weighting matrix that accounts for arbitrary correlation among 
observations within clusters identified by {it:clustvar}.

{marker kernel}{...}
{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel} {it:#}{cmd:)} requests a
heteroskedasticity- and autocorrelation-consistent (HAC) weighting
matrix using the specified kernel (see below) with {it:#} lags.  The
bandwidth of a kernel is equal to {it:#} + 1.

{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel} {cmd:opt} [{it:#}]{cmd:)} requests an
HAC weighting matrix using the specified kernel, and the lag order is selected
using Newey and West's ({help ivregress##NW1994:1994}) optimal lag-selection
algorithm.  {it:#} is an optional tuning parameter that affects the lag order
selected; see the
{mansection R ivregressMethodsandformulaswmatrixopt:discussion}
in {bf:[R] ivregress}.

{pmore}
Specifying {cmd:wmatrix(hac} {it:kernel}{cmd:)} requests an HAC 
weighting matrix using the specified kernel and {it:N}-2 lags, 
where {it:N} is the sample size.

{pmore}
There are three kernels available for HAC weighting matrices, and you 
may request each one by using the name used by statisticians or the 
name perhaps more familiar to economists:

{p 12 16 4}
{opt ba:rtlett} or {opt nw:est} requests the Bartlett (Newey-West) kernel;

{p 12 16 4}
{opt pa:rzen} or {opt ga:llant} requests the Parzen
({help ivregress##G1987:Gallant 1987}) kernel; and

{p 12 16 4}
{opt qu:adraticspectral} or {opt an:drews} requests the quadratic 
spectral ({help ivregress##A1991:Andrews 1991}) kernel.

{pmore}
Specifying {cmd:wmatrix(unadjusted)} requests a weighting matrix that is 
suitable when the errors are homoskedastic.  The GMM estimator with this 
weighting matrix is equivalent to the 2SLS estimator.

{phang}
{opt center} requests that the sample moments be centered (demeaned) 
when computing GMM weight matrices.  By default, centering is not done.

{phang}
{opt igmm} requests that the iterative GMM estimator be used instead of the 
default two-step GMM estimator.  Convergence is declared when the 
relative change in the parameter vector from one iteration to the next 
is less than {cmd:eps()} or the relative change in the weight matrix is 
less than {cmd:weps()}.

{phang}
{opt eps(#)} specifies the convergence criterion for successive
parameter estimates when the iterative GMM estimator is used.
The default is {cmd:eps(1e-6)}.  Convergence is declared when the 
relative difference between successive parameter estimates is less than 
{cmd:eps()} and the relative difference between successive estimates of 
the weighting matrix is less than {cmd:weps()}.

{phang}
{opt weps(#)} specifies the convergence criterion for successive 
estimates of the weighting matrix when the iterative GMM estimator
is used.  The default is {cmd:weps(1e-6)}.  Convergence is declared when the 
relative difference between successive parameter estimates is less than 
{cmd:eps()} and the relative difference between successive estimates of 
the weighting matrix is less than {cmd:weps()}.

{marker optimization_options}{...}
{phang}
{it:optimization_options}: {cmdab:iter:ate()}, [{cmd:no}]{opt log}.  
{cmd:iterate()} specifies the maximum number of iterations to perform in
conjunction with the iterative GMM estimator.  The default is the
number set using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.  {opt log}/{opt nolog} specifies whether to show the iteration
log; see {cmd:set iterlog} in {manhelpi set_iter R:set iter}.  These options
are seldom used.

{dlgtab:SE/Robust}

INCLUDE help vce_rcbj

{pmore}
{cmd:vce(unadjusted)}, the default for {cmd:2sls} and {cmd:liml}, specifies
that an unadjusted (nonrobust) VCE matrix be used. The default for
{cmd:gmm} is based on the {it:wmtype} specified in the {cmd:wmatrix()}
option; see {help ivregress##wmatrix:wmatrix({it:wmtype})} above.
If {cmd:wmatrix()} is specified with {cmd:gmm} but {cmd:vce()} is not, then
{it:vcetype} is set equal to {it:wmtype}.  To override this behavior and
obtain an unadjusted (nonrobust) VCE matrix, specify {cmd:vce(unadjusted)}.

{pmore}
{cmd:ivregress} also allows the following:

{phang2}
{cmd:vce(hac} {it:kernel} [{it:#} | {cmd:opt} [{it:#}]]{cmd:)} specifies that
an HAC covariance matrix be used.  The syntax used with 
{cmd:vce(hac }{it:kernel ...}{cmd:)} is identical to
that used with {cmd:wmatrix(hac }{it:kernel ...} {cmd:)}; see 
{help ivregress##wmatrix:wmatrix({it:wmtype})} above.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} requests that the first-stage regression results be displayed.

{phang}
{opt small} requests that the degrees-of-freedom adjustment 
{it:N}/({it:N}-{it:k}) be made to the variance-covariance matrix of 
parameters and that small-sample {it:F} and {it:t} statistics 
be reported, where {it:N} is the sample size and {it:k} is the number 
of parameters estimated.  By default, no degrees-of-freedom adjustment is 
made, and Wald and {it:z} statistics are reported. Even with this option, no
degrees-of-freedom adjustment is made to the weighting matrix when the GMM
estimator is used.

{phang}
{opt noheader} suppresses the display of the summary
statistics at the top of the output, displaying only the coefficient table.

{phang}
{opth depname:(varname:depname)} is used only in programs and ado-files that
use {cmd:ivregress} to fit models other than instrumental-variables
regression.  {opt depname()} may be specified only at estimation time.
{it:depname} is recorded as the identity of the dependent variable, even
though the estimates are calculated using {depvar}.  This method affects
the labeling of the output -- not the results calculated -- but could affect
later calculations made by {opt predict}, where the residual would be
calculated as deviations from {it:depname} rather than {it:depvar}. 
{opt depname()} is most typically used when {it:depvar} is a temporary variable
(see {manhelp macro P}) used as a proxy for {it:depname}.

{phang}
{opth eform:(strings:string)} is used only in programs and ado-files that use 
{cmd:ivregress} to fit models other than instrumental-variables regression. 
{opt eform()} specifies that the coefficient table be displayed in
"exponentiated form", as defined in {helpb maximize:[R] Maximize}, and that
{it:string} be used to label the exponentiated coefficients in the table.

INCLUDE help displayopts_list

{phang} The following options are available with {cmd:ivregress} but are
not shown in the dialog box:

{phang}
{opt perfect} requests that {cmd:ivregress} not check for collinearity 
between the endogenous regressors and excluded instruments, allowing one 
to specify "perfect" instruments.  This option cannot be used with the
LIML estimator.  This option may be required when using 
{cmd:ivregress} to implement other estimators.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hsng2}{p_end}

{pstd}Fit a regression via 2SLS, requesting small-sample statistics{p_end}
{phang2}{cmd:. ivregress 2sls rent pcturban (hsngval = faminc i.region), small}{p_end}

{pstd}Fit a regression using the LIML estimator{p_end}
{phang2}{cmd:. ivregress liml rent pcturban (hsngval = faminc i.region)}{p_end}

{pstd}Fit a regression via GMM using the default heteroskedasticity-robust weight matrix{p_end}
{phang2}{cmd:. ivregress gmm rent pcturban (hsngval = faminc i.region)}{p_end}

{pstd}Fit a regression via GMM using a heteroskedasticity-robust weight matrix, requesting nonrobust standard errors{p_end}
{phang2}{cmd:. ivregress gmm rent pcturban (hsngval = faminc i.region), vce(unadjusted)}{p_end}

{pstd}Fit a regression via 2SLS, with an endogenous factorial interaction{p_end}
{phang2}{cmd:. ivregress 2sls rent pcturban (c.popgrow##c.popgrow = c.faminc##c.faminc i.region)}{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=lbnswRJ1qV0&index=1&list=UUVk4G4nEtBS4tLOyHqustDA":Instrumental variables regression using Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ivregress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(kappa)}}kappa used in LIML estimator{p_end}
{synopt:{cmd:e(J)}}value of GMM objective function{p_end}
{synopt:{cmd:e(wlagopt)}}lags used in HAC weight matrix (if Newey-West
            algorithm used){p_end}
{synopt:{cmd:e(vcelagopt)}}lags used in HAC VCE matrix (if Newey-West
            algorithm used){p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(iterations)}}number of GMM iterations ({cmd:0} if not applicable)
{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ivregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(instd)}}instrumented variable{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(constant)}}{cmd:noconstant} or {cmd:hasconstant} if specified
{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(estimator)}}{cmd:2sls}, {cmd:liml}, or {cmd:gmm}{p_end}
{synopt:{cmd:e(exogr)}}exogenous regressors{p_end}
{synopt:{cmd:e(wmatrix)}}{it:wmtype} specified in {cmd:wmatrix()}{p_end}
{synopt:{cmd:e(moments)}}{cmd:centered} if {cmd:center} specified{p_end}
{synopt:{cmd:e(small)}}{cmd:small} if small-sample statistics{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(W)}}weight matrix used to compute GMM estimates{p_end}
{synopt:{cmd:e(S)}}moment covariance matrix used to compute GMM
             variance-covariance matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker A1991}{...}
{phang}
Andrews, D. W. K. 1991. Heteroskedasticity and autocorrelation consistent
covariance matrix estimation. {it:Econometrics} 59: 817-858.

{marker G1987}{...}
{phang}
Gallant, A. R. 1987. {it:Nonlinear Statistical Models}. New York: Wiley.

{marker NW1994}{...}
{phang}
Newey, W. K., and K. D. West. 1994. Automatic lag selection in covariance
matrix estimation. {it:Review of Economic Studies} 61: 631-653.
{p_end}
